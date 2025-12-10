extends CharacterBody2D

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
