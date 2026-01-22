extends "res://enemies/enemy.gd"

@export var artifact_scene: PackedScene
@export var artifact_id: String = "relic"
@export var patrol_anchor_path: NodePath
@export var require_quest_active: bool = true
@export var boss_disengage_delay: float = 1.5
@export var phase2_threshold: float = 0.65
@export var phase3_threshold: float = 0.33
@export var phase1_fire_interval: float = 0.55
@export var phase2_fire_interval: float = 0.42
@export var phase3_fire_interval: float = 0.32
@export var phase1_laser_speed: float = 900.0
@export var phase2_laser_speed: float = 1025.0
@export var phase3_laser_speed: float = 1150.0
@export var special_interval_phase2: float = 4.0
@export var special_interval_phase3: float = 3.2
@export var special_telegraph_time: float = 0.35
@export var telegraph_color: Color = Color(1.0, 0.85, 0.25, 1.0)
@export var rage_color: Color = Color(1.0, 0.25, 0.25, 1.0)
@export var phase_minion_count: int = 2

var boss_engaged: bool = false
var _patrol_anchor: Node2D = null
var _boss_active: bool = true
var _initial_collision_layer: int = 0
var _initial_collision_mask: int = 0
var _engaged_timer: float = 0.0
var _phase: int = 1
var _spawned_phase2: bool = false
var _spawned_phase3: bool = false
var _special_cd: float = 0.0
var _special_lock: bool = false
var _cached_sprite: Sprite2D = null

const EnemyScene: PackedScene = preload("res://enemies/Enemy.tscn")

func _ready() -> void:
	super._ready()
	add_to_group("boss")
	_initial_collision_layer = collision_layer
	_initial_collision_mask = collision_mask
	if has_node("Sprite2D"):
		_cached_sprite = $Sprite2D as Sprite2D
	_set_patrol_anchor()
	_refresh_boss_active()
	GameState.state_changed.connect(_on_state_changed)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if _tracking_player:
		boss_engaged = true
		_engaged_timer = boss_disengage_delay
	elif boss_engaged:
		_engaged_timer = maxf(0.0, _engaged_timer - delta)
		if _engaged_timer <= 0.0:
			boss_engaged = false

	_update_phase()
	_apply_phase_stats()
	_update_visuals(delta)
	_try_special_attack(delta)

func _update_phase() -> void:
	if max_health <= 0:
		_phase = 1
		return
	var ratio: float = float(current_health) / float(max_health)
	var new_phase: int = 1
	if ratio <= phase3_threshold:
		new_phase = 3
	elif ratio <= phase2_threshold:
		new_phase = 2

	if new_phase == _phase:
		return

	_phase = new_phase
	if boss_engaged:
		if _phase == 2 and not _spawned_phase2:
			_spawned_phase2 = true
			_spawn_phase_minions(2)
		elif _phase == 3 and not _spawned_phase3:
			_spawned_phase3 = true
			_spawn_phase_minions(3)

func _apply_phase_stats() -> void:
	if _phase == 1:
		fire_interval = phase1_fire_interval
	elif _phase == 2:
		fire_interval = phase2_fire_interval
	else:
		fire_interval = phase3_fire_interval

func _update_visuals(_delta: float) -> void:
	if _cached_sprite == null:
		return
	if _special_lock:
		return
	if _phase >= 3:
		_cached_sprite.modulate = rage_color
	else:
		_cached_sprite.modulate = Color(1, 1, 1, 1)

func _try_special_attack(delta: float) -> void:
	if not boss_engaged:
		return
	if _special_lock:
		return
	_special_cd = maxf(0.0, _special_cd - delta)
	if _special_cd > 0.0:
		return

	if _phase < 2:
		return

	_special_lock = true
	var interval: float = special_interval_phase2
	if _phase >= 3:
		interval = special_interval_phase3
	_special_cd = interval
	call_deferred("_run_special_attack")

func _run_special_attack() -> void:
	if not is_inside_tree():
		_special_lock = false
		return
	if _cached_sprite != null:
		_cached_sprite.modulate = telegraph_color
	await get_tree().create_timer(special_telegraph_time).timeout
	if not is_inside_tree():
		_special_lock = false
		return

	var root: Node = get_tree().current_scene
	if root == null:
		_special_lock = false
		return

	var count: int = 10
	if _phase == 2:
		count = 10
	elif _phase >= 3:
		count = 14

	var damage: int = laser_damage
	if _phase == 2:
		damage += 2
	elif _phase >= 3:
		damage += 4

	var speed: float = phase1_laser_speed
	if _phase == 2:
		speed = phase2_laser_speed
	elif _phase >= 3:
		speed = phase3_laser_speed

	for i in range(count):
		var a: float = (TAU * float(i)) / float(maxi(1, count))
		var shot_dir: Vector2 = Vector2.RIGHT.rotated(a)
		_spawn_laser(root, shot_dir, damage, speed)

	if _cached_sprite != null:
		_cached_sprite.modulate = rage_color if _phase >= 3 else Color(1, 1, 1, 1)
	_special_lock = false

func _spawn_phase_minions(phase: int) -> void:
	if EnemyScene == null:
		return
	var root: Node = get_tree().current_scene
	if root == null:
		return

	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var count: int = max(0, phase_minion_count)
	for i in range(count):
		var inst: Node = EnemyScene.instantiate()
		if not (inst is Node2D):
			continue
		var e := inst as Node2D
		e.set("enemy_id", "basic")
		var diff: float = 1.6
		if phase == 2:
			diff = 1.9
		elif phase == 3:
			diff = 2.2
		e.set("difficulty_multiplier", diff)
		e.scale = Vector2(0.55, 0.55)

		var angle: float = rng.randf_range(0.0, TAU)
		var radius: float = rng.randf_range(420.0, 620.0)
		e.global_position = global_position + Vector2(cos(angle), sin(angle)) * radius
		root.call_deferred("add_child", e)

func is_boss_engaged() -> bool:
	return boss_engaged

func _on_state_changed() -> void:
	_refresh_boss_active()

func _refresh_boss_active() -> void:
	# Verificar se o boss já foi morto
	var zone_id := GameState.current_zone_id
	var boss_id := "boss_%s" % zone_id
	var should_show := not GameState.defeated_bosses.has(boss_id)
	_set_boss_active(should_show)

func _set_boss_active(active: bool) -> void:
	_boss_active = active
	boss_engaged = false
	_engaged_timer = 0.0
	visible = active
	set_process(active)
	set_physics_process(active)
	if active:
		collision_layer = _initial_collision_layer
		collision_mask = _initial_collision_mask
	else:
		collision_layer = 0
		collision_mask = 0
		velocity = Vector2.ZERO

func _set_patrol_anchor() -> void:
	var anchor: Node2D = null
	if patrol_anchor_path != NodePath():
		anchor = get_node_or_null(patrol_anchor_path) as Node2D
	if anchor == null:
		var marker := get_tree().get_first_node_in_group("boss_planet_marker")
		if marker is Node2D:
			anchor = marker as Node2D
	if anchor != null:
		_patrol_anchor = anchor
		_patrol_center = _patrol_anchor.global_position
		_pick_patrol_target()

func die() -> void:
	_spawn_boss_artifact()
	# Registrar que este boss foi morto
	var zone_id := GameState.current_zone_id
	var boss_id := "boss_%s" % zone_id
	if not GameState.defeated_bosses.has(boss_id):
		GameState.defeated_bosses.append(boss_id)
		GameState.emit_signal("state_changed")
		GameState._queue_save()
	super.die()
	GameState.complete_quest(GameState.QUEST_BOSS_PLANET)

func _spawn_boss_artifact() -> void:
	if artifact_scene == null:
		artifact_scene = load("res://pickups/ArtifactPart.tscn")
	if artifact_scene == null:
		return

	var part := artifact_scene.instantiate()
	if part is Node2D:
		(part as Node2D).set_as_top_level(true)
	part.global_position = global_position
	part.set("artifact_id", artifact_id)

	var zone_root := GameState.get_zone_root_node()
	var root := zone_root as Node if zone_root != null else get_tree().current_scene
	if root != null:
		root.call_deferred("add_child", part)

func _shoot(dir_to_player: Vector2) -> void:
	if laser_scene == null:
		laser_scene = load("res://player/lasers/Laser.tscn")
	if laser_scene == null:
		return

	var root: Node = get_tree().current_scene
	if root == null:
		return

	var dir := dir_to_player.normalized()
	if dir == Vector2.ZERO:
		return

	var damage: int = laser_damage
	if _phase == 2:
		damage += 2
	elif _phase >= 3:
		damage += 4

	var speed: float = phase1_laser_speed
	if _phase == 2:
		speed = phase2_laser_speed
	elif _phase >= 3:
		speed = phase3_laser_speed

	if _phase == 1:
		# Dual lasers (slight spread)
		var perp := Vector2(-dir.y, dir.x)
		var offsets: Array[Vector2] = [perp * 18.0, -perp * 18.0]
		for offset in offsets:
			_spawn_laser_at(root, dir, damage, speed, offset)
	elif _phase == 2:
		# Triple spread
		_fire_spread(root, dir, 5, 0.34, damage, speed)
	else:
		# Mix: spread + mini burst
		_fire_spread(root, dir, 7, 0.32, damage, speed)
		_fire_radial(root, 8, damage - 1, speed)

func take_damage(amount: int) -> void:
	if amount <= 0:
		return
	current_health -= amount
	if current_health <= 0:
		die()
		return
	_update_phase()

func _fire_spread(root: Node, dir_to_player: Vector2, count: int, spread_radians: float, damage: int, speed: float) -> void:
	var base_angle: float = dir_to_player.angle()
	var c: int = maxi(1, count)
	for i in range(c):
		var t: float = 0.0 if c == 1 else float(i) / float(c - 1)
		var a: float = lerp(-spread_radians, spread_radians, t)
		var shot_dir: Vector2 = Vector2.RIGHT.rotated(base_angle + a)
		_spawn_laser(root, shot_dir, damage, speed)

func _fire_radial(root: Node, count: int, damage: int, speed: float) -> void:
	var c: int = maxi(1, count)
	for i in range(c):
		var a: float = (TAU * float(i)) / float(c)
		var shot_dir: Vector2 = Vector2.RIGHT.rotated(a)
		_spawn_laser(root, shot_dir, damage, speed)

func _spawn_laser(root: Node, dir: Vector2, damage: int, speed: float) -> void:
	_spawn_laser_at(root, dir.normalized(), damage, speed, Vector2.ZERO)

func _spawn_laser_at(root: Node, dir: Vector2, damage: int, speed: float, offset: Vector2) -> void:
	var inst: Node = laser_scene.instantiate()
	if not (inst is Area2D):
		return
	var laser := inst as Area2D
	laser.global_position = global_position + dir * 44.0 + offset
	laser.set("direction", dir)
	laser.set("rotation", dir.angle() - Vector2.UP.angle())
	laser.set("damage", damage)
	laser.set("speed", speed)
	laser.set("from_player", false)
	root.call_deferred("add_child", laser)
