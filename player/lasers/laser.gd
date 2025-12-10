extends Area2D

@export var speed := 800.0
var direction: Vector2 = Vector2.UP   # vai ser definido pela nave
var lifetime := 2.0                      # segundos até desaparecer


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta	

	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
