extends CharacterBody2D

const ACCELERATION := 600.0      # força do motor
const MAX_SPEED := 500.0         # velocidade máxima
const FRICTION := 100.0          # “atrito” para não ficar eterno
const ROTATION_SPEED := 3.0      # radianos por segundo (rotação)

func _physics_process(delta: float) -> void:
	# 1. Rodar nave (esquerda / direita)
	var turn_dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	rotation += turn_dir * ROTATION_SPEED * delta

	# 2. Thrust (acelerar para a frente / trás)
	var thrust := Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")

	if thrust != 0.0:
		# Vector2.RIGHT é a direção “para a frente” do sprite por defeito
		var forward := Vector2.RIGHT.rotated(rotation)
		velocity += forward * thrust * ACCELERATION * delta
	else:
		# Aplica um pouquinho de “travão” para não ficar a flutuar para sempre
		if velocity.length() > 0.0:
			var friction_force := FRICTION * delta
			if friction_force > velocity.length():
				velocity = Vector2.ZERO
			else:
				velocity -= velocity.normalized() * friction_force

	# 3. Limitar velocidade máxima
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED

	# 4. Mover a nave com a velocidade atual
	move_and_slide()
