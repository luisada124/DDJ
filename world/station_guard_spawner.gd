extends Node2D

const EnemyScene: PackedScene = preload("res://enemies/Enemy.tscn")

@export var enabled: bool = true

# Encontro por estação: mata X inimigos e para de spawnar até saíres longe e voltares.
@export var wave_total: int = 10
@export var max_alive: int = 5

# Distâncias são relativas ao centro da estação.
@export var activation_distance: float = 1600.0
@export var reset_distance: float = 2800.0

# Raios de spawn são "fora" da bolha segura: raio real = station_safe_radius + spawn_radius_min/max
@export var spawn_radius_min: float = 120.0
@export var spawn_radius_max: float = 520.0
@export var respawn_interval: float = 2.0

@export var station_safe_radius: float = 450.0
@export var chase_range_override: float = 2600.0
@export var guard_desired_distance: float = 420.0
@export var enemy_scale: Vector2 = Vector2(0.5, 0.5)
@export var enforce_offscreen_spawn: bool = true
@export var offscreen_margin: float = 120.0
@export var spawn_attempts: int = 12

var _guards: Array[Node] = []
var _timer: Timer
var _wave_kills: int = 0
var _wave_spawned: int = 0

func is_wave_cleared() -> bool:
	if not enabled:
		return true
	if wave_total <= 0:
		return true
	return _wave_kills >= wave_total

func get_wave_kills() -> int:
	return _wave_kills

func get_wave_total() -> int:
	if not enabled:
		return 0
	return wave_total

func _ready() -> void:
	_apply_station_overrides()
	if not enabled:
		return

	_timer = Timer.new()
	_timer.one_shot = false
	_timer.wait_time = respawn_interval
	_timer.autostart = true
	_timer.timeout.connect(_ensure_guards)
	add_child(_timer)

	call_deferred("_ensure_guards")

func _apply_station_overrides() -> void:
	var station := get_parent()
	if station == null:
		return

	var station_id_variant: Variant = station.get("station_id")
	var station_id := ""
	if station_id_variant != null:
		station_id = str(station_id_variant)

	match station_id:
		"station_kappa":
			# Posto de tutorial: sem guardas.
			enabled = false
			wave_total = 0
			max_alive = 0
		"station_epsilon":
			wave_total = 3
			max_alive = 3
		"station_delta":
			wave_total = 3
			max_alive = 3
		"station_alpha":
			wave_total = 5
			max_alive = 5

func _ensure_guards() -> void:
	if not enabled:
		return

	var station := get_parent()
	if station == null or not (station is Node2D):
		return
	var station_node := station as Node2D

	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null or not is_instance_valid(player):
		return

	var player_dist := (player.global_position - station_node.global_position).length()
	if player_dist >= reset_distance:
		_reset_wave()
		return

	if player_dist > activation_distance:
		return

	var alive: Array[Node] = []
	for n in _guards:
		if n != null and is_instance_valid(n):
			alive.append(n)
	_guards = alive

	if wave_total <= 0:
		return

	# Se já limpou a wave, não volta a spawnar enquanto estiver perto.
	if _wave_kills >= wave_total:
		_despawn_all_guards()
		return

	var remaining_to_spawn: int = maxi(0, wave_total - _wave_spawned)
	if remaining_to_spawn <= 0:
		return

	var desired_alive: int = mini(max_alive, remaining_to_spawn)
	while _guards.size() < desired_alive:
		var e := _spawn_guard()
		if e == null:
			break
		_guards.append(e)

func _spawn_guard() -> Node:
	if EnemyScene == null:
		return null

	var station := get_parent()
	if station == null or not (station is Node2D):
		return null
	var station_node := station as Node2D

	var inst := EnemyScene.instantiate()
	if inst == null:
		return null
	if inst is Node2D:
		var camera := get_viewport().get_camera_2d()
		(inst as Node2D).global_position = _random_spawn_pos(station_node.global_position, camera)
		(inst as Node2D).scale = enemy_scale

	var enemy_id := _pick_enemy_id()
	if inst.has_method("set"):
		inst.set("enemy_id", enemy_id)
		inst.set("difficulty_multiplier", 1.0)
		inst.set("desired_distance", guard_desired_distance)
		inst.set("chase_range", chase_range_override)

		# Ajuda o AI a respeitar a "bolha" da estação sem precisar de procurar pelo mapa todo.
		inst.set("home_station", station_node)
		inst.set("station_safe_radius", station_safe_radius)

	if inst.has_signal("tree_exited"):
		inst.tree_exited.connect(_on_guard_tree_exited.bind(inst))

	var root := get_tree().current_scene
	if root == null:
		return null
	root.call_deferred("add_child", inst)

	_wave_spawned += 1
	return inst

func _random_spawn_pos(center: Vector2, camera: Camera2D) -> Vector2:
	var base: float = maxf(0.0, station_safe_radius)
	var tries: int = maxi(1, spawn_attempts)
	for _i in range(tries):
		var r: float = base + randf_range(spawn_radius_min, spawn_radius_max)
		var a: float = randf_range(0.0, TAU)
		var pos := center + Vector2(cos(a), sin(a)) * r
		if not enforce_offscreen_spawn:
			return pos
		if camera == null or not _is_in_camera_view(pos, camera):
			return pos

	var r_fallback: float = base + spawn_radius_max
	var a_fallback: float = randf_range(0.0, TAU)
	return center + Vector2(cos(a_fallback), sin(a_fallback)) * r_fallback

func _is_in_camera_view(pos: Vector2, camera: Camera2D) -> bool:
	if camera == null:
		return false
	var viewport_size := get_viewport().get_visible_rect().size
	var zoom := camera.zoom
	var world_view_size := viewport_size / zoom
	var cam_pos := camera.global_position
	var half := world_view_size * 0.5
	var left := cam_pos.x - half.x - offscreen_margin
	var right := cam_pos.x + half.x + offscreen_margin
	var top := cam_pos.y - half.y - offscreen_margin
	var bottom := cam_pos.y + half.y + offscreen_margin
	return pos.x >= left and pos.x <= right and pos.y >= top and pos.y <= bottom

func _on_guard_tree_exited(guard: Node) -> void:
	var despawned := false
	if guard != null and is_instance_valid(guard):
		despawned = bool(guard.get_meta("station_guard_despawned", false))

	_remove_guard(guard)

	if despawned:
		return
	_wave_kills += 1

func _remove_guard(guard: Node) -> void:
	var next: Array[Node] = []
	for n in _guards:
		if n != guard and n != null and is_instance_valid(n):
			next.append(n)
	_guards = next

func _despawn_all_guards() -> void:
	for n in _guards:
		if n == null or not is_instance_valid(n):
			continue
		n.set_meta("station_guard_despawned", true)
		n.queue_free()
	_guards.clear()

func _reset_wave() -> void:
	_despawn_all_guards()
	_wave_kills = 0
	_wave_spawned = 0

func _pick_enemy_id() -> String:
	match GameState.current_zone_id:
		"inner":
			return "tank" if randf() < 0.45 else "sniper"
		"mid":
			return "sniper" if randf() < 0.55 else "basic"
		_:
			return "basic"
