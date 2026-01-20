extends CharacterBody2D

const KNOCKBACK_FORCE := 400.0      # força do empurrão para trás
const INVINCIBILITY_TIME := 1.0     # segundos sem levar dano


var invincible: bool = false
var invincible_timer: float = 0.0

const SHIP_FORWARD := Vector2.UP

const DRAG := 0.5
const ROTATION_SPEED := 3.0
const LaserScene := preload("res://player/lasers/Laser.tscn")
const AlienScene: PackedScene = preload("res://player/Alien.tscn")

var fire_cooldown: float = 0.0
var _controlling_alien: bool = false
var _alien: CharacterBody2D = null

@onready var _camera: Camera2D = $Camera2D
@export var alien_camera_zoom: Vector2 = Vector2(1.6, 1.6)

var _saved_ship_zoom: Vector2 = Vector2.ONE

func take_damage(amount: int) -> void:
	if invincible:
		return

	GameState.damage_player(amount)

	# Invencibilidade
	invincible = true
	invincible_timer = INVINCIBILITY_TIME

func shoot() -> void:
	# direção da frente da nave
	var dir := SHIP_FORWARD.rotated(rotation)

	var muzzle_points = [ $GunLeft, $GunRight ]

	for muzzle in muzzle_points:
		var laser = LaserScene.instantiate()
		laser.global_position = muzzle.global_position
		laser.direction = dir
		laser.inherited_velocity = velocity
		laser.from_player = true  # <- garante que é tiro do player
		get_tree().current_scene.add_child(laser)


func _physics_process(delta: float) -> void:
	if _controlling_alien:
		# se o alien morreu/desapareceu, volta para a nave
		if _alien == null or not is_instance_valid(_alien):
			_controlling_alien = false
			add_to_group("player")
			_set_camera_zoom_input_enabled(true)
			_move_camera_to(self, _saved_ship_zoom)
			return

		# nave fica em "idle" enquanto controlas o alien
		if has_node("ThrusterParticles"):
			$ThrusterParticles.emitting = false
		if velocity.length() > 0.0:
			velocity = velocity.lerp(Vector2.ZERO, DRAG * delta)
		move_and_slide()
		_check_collisions()

		if invincible:
			invincible_timer -= delta
			if invincible_timer <= 0.0:
				invincible = false
		return

	# 1) Rodar nave
	var turn_dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	rotation += turn_dir * ROTATION_SPEED * delta

	# 2) Thrust (motor)
	var thrust_pressed := Input.is_action_pressed("ui_up")
	var reverse_pressed: bool = Input.is_action_pressed("ui_down") and GameState.has_reverse_thruster()
	var engine_pressed: bool = thrust_pressed or reverse_pressed
	var forward_dir := SHIP_FORWARD.rotated(rotation)

	if has_node("ThrusterParticles"):
		$ThrusterParticles.emitting = engine_pressed

	if thrust_pressed:
		velocity += forward_dir * GameState.get_acceleration() * delta
	if reverse_pressed:
		velocity += -forward_dir * GameState.get_acceleration() * GameState.get_reverse_thrust_factor() * delta

	if not engine_pressed:
		if velocity.length() > 0.0:
			velocity = velocity.lerp(Vector2.ZERO, DRAG * delta)

	# 3) Limitar velocidade
	var max_speed := GameState.get_max_speed()
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	# 4) Mover
	move_and_slide()

	# 5) Disparo contínuo com cooldown
	fire_cooldown -= delta
	if Input.is_action_pressed("shoot") and fire_cooldown <= 0.0:
		shoot()
		fire_cooldown = GameState.get_fire_interval()

	# 6) Verificar colisões
	_check_collisions()
	
	# 7) Atualizar invencibilidade
	if invincible:
		invincible_timer -= delta
		if invincible_timer <= 0.0:
			invincible = false


func _check_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider != null and collider.is_in_group("comet"):
			# só leva dano se não estiver invencível
			if not invincible:
				GameState.damage_player(10)
				print("Bateu num cometa!")

				# Knockback
				var normal: Vector2 = collision.get_normal()
				velocity = normal * KNOCKBACK_FORCE

				# Invencibilidade
				invincible = true
				invincible_timer = INVINCIBILITY_TIME

			# Explodir sempre que toca (mesmo se invencível)
			if collider.has_method("explode"):
				collider.explode()
			else:
				collider.queue_free()
			continue

		if collider != null and collider.is_in_group("enemy"):
			if not invincible:
				var dmg := 10
				var contact_dmg = collider.get("contact_damage")
				if contact_dmg != null:
					dmg = int(contact_dmg)

				GameState.damage_player(dmg)
				print("Bateu num inimigo!")

				# Knockback
				var normal: Vector2 = collision.get_normal()
				velocity = normal * KNOCKBACK_FORCE

				# Invencibilidade
				invincible = true
				invincible_timer = INVINCIBILITY_TIME

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("eva_toggle"):
		_toggle_eva()
		get_viewport().set_input_as_handled()

func _toggle_eva() -> void:
	if _controlling_alien:
		_try_dock_alien()
		return
	_spawn_alien()

func _spawn_alien() -> void:
	if AlienScene == null:
		return

	var inst: Node = AlienScene.instantiate()
	if not (inst is CharacterBody2D):
		return

	_alien = inst as CharacterBody2D
	var current_scene: Node = get_tree().current_scene
	if current_scene == null:
		return
	current_scene.add_child(_alien)

	_alien.global_position = global_position + Vector2(0, 48)
	_alien.add_to_group("player")
	_alien.add_to_group("alien")
	remove_from_group("player")

	if _alien.has_method("setup"):
		_alien.call("setup", self)

	_controlling_alien = true
	GameState.reset_alien_health()
	_save_ship_camera_zoom()
	_move_camera_to(_alien, alien_camera_zoom)
	_set_camera_zoom_input_enabled(false)

func _try_dock_alien() -> void:
	if _alien == null or not is_instance_valid(_alien):
		_controlling_alien = false
		add_to_group("player")
		_set_camera_zoom_input_enabled(true)
		_move_camera_to(self, _saved_ship_zoom)
		return

	var dist: float = global_position.distance_to(_alien.global_position)
	if dist <= 70.0:
		_on_alien_dock_requested()

func _on_alien_dock_requested() -> void:
	_controlling_alien = false
	add_to_group("player")
	_set_camera_zoom_input_enabled(true)

	if _alien != null and is_instance_valid(_alien):
		_alien.remove_from_group("player")
		_alien.remove_from_group("alien")
		_alien.queue_free()
	_alien = null

	_move_camera_to(self, _saved_ship_zoom)

func _save_ship_camera_zoom() -> void:
	if _camera == null or not is_instance_valid(_camera):
		return

	if _camera.has_method("get_target_zoom"):
		var tz = _camera.call("get_target_zoom")
		if tz is Vector2:
			_saved_ship_zoom = tz
		else:
			_saved_ship_zoom = _camera.zoom
	else:
		_saved_ship_zoom = _camera.zoom

func _move_camera_to(target: Node, zoom_override: Vector2) -> void:
	if _camera == null or not is_instance_valid(_camera):
		return
	if target == null or not is_instance_valid(target):
		return

	_camera.reparent(target, true)
	_camera.position = Vector2.ZERO

	_set_camera_zoom_immediate(zoom_override)

func _set_camera_zoom_immediate(new_zoom: Vector2) -> void:
	if _camera == null or not is_instance_valid(_camera):
		return

	if _camera.has_method("set_target_zoom_immediate"):
		_camera.call("set_target_zoom_immediate", new_zoom)
	else:
		_camera.zoom = new_zoom

func _set_camera_zoom_input_enabled(enabled: bool) -> void:
	if _camera == null or not is_instance_valid(_camera):
		return

	if _camera.has_method("set_zoom_input_enabled"):
		_camera.call("set_zoom_input_enabled", enabled)
