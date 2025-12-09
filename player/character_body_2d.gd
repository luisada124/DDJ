extends CharacterBody2D

# Direção da FRENTE da nave na textura:
# Se o nariz estiver virado para cima usa UP, se for para a direita usa RIGHT, etc.
const SHIP_FORWARD := Vector2.UP

const ACCELERATION := 700.0     # força do motor
const MAX_SPEED := 500.0        # velocidade máxima
const DRAG := 0.5               # 0 = sem travão, 1 = trava muito
const ROTATION_SPEED := 3.0     # radianos por segundo

func _physics_process(delta: float) -> void:
	# 1) Rodar nave
	var turn_dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	rotation += turn_dir * ROTATION_SPEED * delta

	# 2) Thrust (motor) – vem de trás mas empurra a nave para a frente
	var thrust_pressed := Input.is_action_pressed("ui_up")

	# ligar/desligar fogo (se tiveres o nó ThrusterParticles como filho da nave)
	if has_node("ThrusterParticles"):
		$ThrusterParticles.emitting = thrust_pressed

	if thrust_pressed:
		# direção da FRENTE da nave no mundo
		var forward_dir := SHIP_FORWARD.rotated(rotation)
		velocity += forward_dir * ACCELERATION * delta
	else:
		# arrasto suave para não ficar a planar para sempre
		if velocity.length() > 0.0:
			velocity = velocity.lerp(Vector2.ZERO, DRAG * delta)

	# 3) Limitar velocidade
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED

	# 4) Mover
	move_and_slide()
