extends Area2D

@export var speed: float = 800.0
@export var damage: int = 5

var direction: Vector2 = Vector2.UP
var lifetime: float = 2.0

# true = tiro do player, false = tiro de inimigo
var from_player: bool = true


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	# print("LASER hit:", body, " groups =", body.get_groups())

	if from_player:
		# ========= TIRO DO PLAYER =========
		# Acerta cometas
		if body.is_in_group("comet") and body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
			return

		# Acerta inimigos
		if body.is_in_group("enemy") and body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
			return

	else:
		# ========= TIRO DO INIMIGO =========
		# Só interessa o player
		if body.is_in_group("player"):
			GameState.damage_player(damage)
			queue_free()
			return

	# Se chegou aqui:
	# - tiro do player que bateu no player
	# - tiro do player que bateu em parede/pickup/etc
	# - tiro do inimigo que bateu em inimigo/cometa
	# -> ignorar completamente (não dano, não destruir laser)
