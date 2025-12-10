extends Area2D

@export var speed: float = 800.0
@export var damage: int = 5
var direction: Vector2 = Vector2.UP
var lifetime: float = 2.0

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("comet") and body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
