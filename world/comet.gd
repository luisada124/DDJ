extends Area2D

@export var speed: float = 80.0
@export var direction: Vector2 = Vector2.LEFT

func _ready() -> void:
	add_to_group("comet")

func _process(delta: float) -> void:
	position += direction * speed * delta
