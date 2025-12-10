extends CharacterBody2D

const KNOCKBACK_FORCE := 400.0      # força do empurrão para trás
const INVINCIBILITY_TIME := 1.0     # segundos sem levar dano


var invincible: bool = false
var invincible_timer: float = 0.0

const SHIP_FORWARD := Vector2.UP

const ACCELERATION := 700.0
const MAX_SPEED := 500.0
const DRAG := 0.5
const ROTATION_SPEED := 3.0
const LaserScene := preload("res://player/lasers/Laser.tscn")

const FIRE_INTERVAL := 0.2  # segundos entre tiros
var fire_cooldown: float = 0.0

func shoot() -> void:
	# direção da frente da nave
	var dir := SHIP_FORWARD.rotated(rotation)

	var muzzle_points = [ $GunLeft, $GunRight ]

	for muzzle in muzzle_points:
		var laser = LaserScene.instantiate()
		laser.global_position = muzzle.global_position
		laser.direction = dir
		get_tree().current_scene.add_child(laser)


func _physics_process(delta: float) -> void:
	# 1) Rodar nave
	var turn_dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	rotation += turn_dir * ROTATION_SPEED * delta

	# 2) Thrust (motor)
	var thrust_pressed := Input.is_action_pressed("ui_up")

	if has_node("ThrusterParticles"):
		$ThrusterParticles.emitting = thrust_pressed

	if thrust_pressed:
		var forward_dir := SHIP_FORWARD.rotated(rotation)
		velocity += forward_dir * ACCELERATION * delta
	else:
		if velocity.length() > 0.0:
			velocity = velocity.lerp(Vector2.ZERO, DRAG * delta)

	# 3) Limitar velocidade
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED

	# 4) Mover
	move_and_slide()

	# 5) Disparo contínuo com cooldown
	fire_cooldown -= delta
	if Input.is_action_pressed("shoot") and fire_cooldown <= 0.0:
		shoot()
		fire_cooldown = FIRE_INTERVAL

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
