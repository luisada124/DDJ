extends CharacterBody2D

const LaserScene: PackedScene = preload("res://player/lasers/Laser.tscn")
const SHIP_FORWARD := Vector2.UP

@export var texture: Texture2D = preload("res://textures/boss-final-removebg-preview.png")

@export var base_max_health: int = 2400
@export var base_move_speed: float = 210.0
@export var orbit_distance: float = 820.0
@export var engage_distance: float = 3200.0

@export var laser_speed: float = 900.0
@export var base_laser_damage: int = 12

@export var phase2_threshold: float = 0.65
@export var phase3_threshold: float = 0.33

@export var telegraph_color: Color = Color(1.0, 0.85, 0.25, 1.0)
@export var rage_color: Color = Color(1.0, 0.25, 0.25, 1.0)

@export var phase1_fire_interval: float = 1.10
@export var phase2_fire_interval: float = 0.85
@export var phase3_fire_interval: float = 0.70

@export var dash_telegraph_time: float = 0.75
@export var dash_duration: float = 0.30
@export var dash_speed: float = 1400.0
@export var dash_cooldown: float = 3.2

@export var phase_minion_count: int = 5

const EnemyScene: PackedScene = preload("res://enemies/Enemy.tscn")

var max_health: int = 1
var current_health: int = 1
var boss_engaged: bool = false

var _phase: int = 1
var _rng := RandomNumberGenerator.new()
var _fire_cd: float = 0.0
var _dash_cd: float = 0.0
var _dash_time_left: float = 0.0
var _dash_dir: Vector2 = Vector2.ZERO
var _telegraph_time_left: float = 0.0
var _summon_cd: float = 0.0
var _attack_lock: bool = false
var _spawned_phase1: bool = false
var _spawned_phase2: bool = false
var _spawned_phase3: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("enemy")
	add_to_group("boss")
	_rng.randomize()

	if sprite != null and texture != null:
		sprite.texture = texture

	var scale_mult := _get_balance_multiplier()
	max_health = int(round(float(base_max_health) * scale_mult))
	current_health = max_health
	_fire_cd = 1.2
	_dash_cd = 3.5
	_summon_cd = 0.0

func is_boss_engaged() -> bool:
	return boss_engaged

func take_damage(amount: int) -> void:
	if amount <= 0:
		return
	current_health = max(current_health - amount, 0)
	_update_phase()
	if current_health <= 0:
		_die()

func _die() -> void:
	# Registrar que este boss foi morto
	var zone_id := GameState.current_zone_id
	var boss_id := "boss_%s" % zone_id
	if not GameState.defeated_bosses.has(boss_id):
		GameState.defeated_bosses.append(boss_id)
		GameState.emit_signal("state_changed")
		GameState._queue_save()
	GameState.emit_signal("speech_requested_timed", "finalmente acabei com esta especie irritante, Vou maze dormir...", 9.0)
	queue_free()

func _physics_process(delta: float) -> void:
	var player := _get_player()
	if player == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var to_player := player.global_position - global_position
	var dist := to_player.length()
	var dir := Vector2.ZERO
	if dist > 0.001:
		dir = to_player / dist
	rotation = dir.angle() - SHIP_FORWARD.angle()
	var was_engaged := boss_engaged
	boss_engaged = dist <= engage_distance

	# Fase 1: ao iniciar combate, spawna 5 inimigos.
	if boss_engaged and not was_engaged and not _spawned_phase1:
		_spawned_phase1 = true
		_spawn_phase_minions(1)

	if not boss_engaged:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	_update_phase()

	_fire_cd = maxf(0.0, _fire_cd - delta)
	_dash_cd = maxf(0.0, _dash_cd - delta)
	_summon_cd = 0.0

	if _telegraph_time_left > 0.0:
		_telegraph_time_left = maxf(0.0, _telegraph_time_left - delta)
		if sprite != null:
			sprite.modulate = telegraph_color
	elif sprite != null:
		sprite.modulate = rage_color if _phase >= 2 else Color(1, 1, 1, 1)

	if _dash_time_left > 0.0:
		_dash_time_left = maxf(0.0, _dash_time_left - delta)
		velocity = _dash_dir * dash_speed
		move_and_slide()
		return

	# Movimento: orbita e mantém distância
	var desired := orbit_distance
	var tangent := Vector2(-dir.y, dir.x)
	var target_vel := tangent * base_move_speed
	if dist > desired + 80.0:
		target_vel += dir * (base_move_speed * 0.75)
	elif dist < desired - 80.0:
		target_vel += -dir * (base_move_speed * 0.75)

	velocity = velocity.lerp(target_vel, 2.5 * delta)
	move_and_slide()

	# Ataques (com janelas e telegraph)
	if not _attack_lock:
		if _phase >= 2 and _dash_cd <= 0.0:
			_try_start_dash(dir)

		if _fire_cd <= 0.0:
			_try_fire(dir)

func _try_fire(dir_to_player: Vector2) -> void:
	if dir_to_player == Vector2.ZERO:
		return
	var interval := phase1_fire_interval
	if _phase == 2:
		interval = phase2_fire_interval
	elif _phase == 3:
		interval = phase3_fire_interval

	_fire_cd = interval
	_attack_lock = true
	_telegraph_time_left = 0.28
	await get_tree().create_timer(0.28).timeout
	_attack_lock = false
	if not is_inside_tree():
		return
	if sprite != null:
		sprite.modulate = Color(1, 1, 1, 1)

	var dmg := _get_laser_damage()
	if _phase == 1:
		_fire_spread(dir_to_player, 5, 0.30, dmg)
	elif _phase == 2:
		_fire_spread(dir_to_player, 7, 0.38, dmg)
	else:
		_fire_radial(14, dmg)
		_fire_spread(dir_to_player, 7, 0.28, dmg)

func _fire_spread(dir_to_player: Vector2, count: int, spread_radians: float, dmg: int) -> void:
	var root := get_tree().current_scene
	if root == null:
		return
	var base_angle := dir_to_player.angle()
	var c: int = max(1, count)
	for i in range(c):
		var t: float = 0.0 if c == 1 else float(i) / float(c - 1)
		var a: float = lerp(-spread_radians, spread_radians, t)
		var shot_dir: Vector2 = Vector2.RIGHT.rotated(base_angle + a)
		_spawn_laser(root, shot_dir, dmg)

func _fire_radial(count: int, dmg: int) -> void:
	var root := get_tree().current_scene
	if root == null:
		return
	var c: int = max(1, count)
	for i in range(c):
		var a: float = (TAU * float(i)) / float(c)
		var shot_dir: Vector2 = Vector2.RIGHT.rotated(a)
		_spawn_laser(root, shot_dir, dmg)

func _spawn_laser(root: Node, dir: Vector2, dmg: int) -> void:
	if LaserScene == null:
		return
	var inst := LaserScene.instantiate()
	if not (inst is Area2D):
		return
	var laser := inst as Area2D
	laser.global_position = global_position + dir.normalized() * 56.0
	laser.set("direction", dir.normalized())
	laser.set("speed", laser_speed)
	laser.set("damage", dmg)
	laser.set("from_player", false)
	root.call_deferred("add_child", laser)

func _try_start_dash(dir_to_player: Vector2) -> void:
	if dir_to_player == Vector2.ZERO:
		return
	_dash_cd = dash_cooldown
	_attack_lock = true
	_telegraph_time_left = dash_telegraph_time
	await get_tree().create_timer(dash_telegraph_time).timeout
	_attack_lock = false
	if not is_inside_tree():
		return
	_dash_dir = dir_to_player.normalized()
	_dash_time_left = dash_duration

func _spawn_phase_minions(phase: int) -> void:
	var root := get_tree().current_scene
	if root == null or EnemyScene == null:
		return
	var player := _get_player()
	if player == null:
		return
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# Obter câmera e calcular área visível
	var camera: Camera2D = get_viewport().get_camera_2d()
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var zoom: Vector2 = Vector2(1.0, 1.0)
	var cam_pos: Vector2 = player.global_position
	if camera != null:
		zoom = camera.zoom
		cam_pos = camera.global_position
	
	var world_view_size: Vector2 = viewport_size / zoom
	var spawn_margin: float = 200.0  # Margem extra para garantir que está fora da tela
	
	# Calcular limites da área visível
	var left: float = cam_pos.x - world_view_size.x / 2.0 - spawn_margin
	var right: float = cam_pos.x + world_view_size.x / 2.0 + spawn_margin
	var top: float = cam_pos.y - world_view_size.y / 2.0 - spawn_margin
	var bottom: float = cam_pos.y + world_view_size.y / 2.0 + spawn_margin

	var count: int = max(0, phase_minion_count)
	for i in range(count):
		var inst: Node = EnemyScene.instantiate()
		if not (inst is Node2D):
			continue
		var e := inst as Node2D
		e.set("enemy_id", "basic")
		var diff: float = 1.6 * _get_balance_multiplier()
		if phase == 2:
			diff = 1.9 * _get_balance_multiplier()
		elif phase == 3:
			diff = 2.2 * _get_balance_multiplier()
		e.set("difficulty_multiplier", diff)
		e.scale = Vector2(0.5, 0.5)
		
		# Spawnar fora da área de visão - escolher um lado aleatório
		var side: int = rng.randi_range(0, 3)
		var spawn_pos: Vector2
		match side:
			0:  # Topo
				spawn_pos = Vector2(rng.randf_range(left, right), top)
			1:  # Fundo
				spawn_pos = Vector2(rng.randf_range(left, right), bottom)
			2:  # Esquerda
				spawn_pos = Vector2(left, rng.randf_range(top, bottom))
			_:  # Direita
				spawn_pos = Vector2(right, rng.randf_range(top, bottom))
		
		e.global_position = spawn_pos
		root.add_child(e)

func _update_phase() -> void:
	if max_health <= 0:
		_phase = 1
		return
	var ratio := float(current_health) / float(max_health)
	var new_phase := 1
	if ratio <= phase3_threshold:
		new_phase = 3
	elif ratio <= phase2_threshold:
		new_phase = 2

	if new_phase != _phase:
		_phase = new_phase
		# Spawn de 5 inimigos por fase.
		if boss_engaged:
			if _phase == 2 and not _spawned_phase2:
				_spawned_phase2 = true
				_spawn_phase_minions(2)
			elif _phase == 3 and not _spawned_phase3:
				_spawned_phase3 = true
				_spawn_phase_minions(3)
	else:
		_phase = new_phase

func _get_player() -> CharacterBody2D:
	var p := get_tree().get_first_node_in_group("player")
	if p is CharacterBody2D:
		return p as CharacterBody2D
	return null

func _get_balance_multiplier() -> float:
	# Balanceado para upgrades >= 8: quanto mais acima, mais HP/dano do boss.
	var sum_levels: float = 0.0
	var count: float = 0.0
	for k in GameState.upgrades.keys():
		var id := str(k)
		sum_levels += float(GameState.get_upgrade_level(id))
		count += 1.0
	var avg := 0.0 if count <= 0.0 else (sum_levels / count)
	var above := maxf(0.0, avg - 8.0)
	return clamp(1.0 + above * 0.35, 1.0, 2.5)

func _get_laser_damage() -> int:
	var m := _get_balance_multiplier()
	var base := float(base_laser_damage)
	if _phase == 2:
		base += 2.0
	elif _phase == 3:
		base += 4.0
	return int(round(base * m))
