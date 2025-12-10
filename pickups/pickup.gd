extends Area2D

@export var resource_type: String = "scrap"
@export var amount: int = 1
@export var spin_speed: float = 2.0

func _ready() -> void:
	add_to_group("pickup")

func _process(delta: float) -> void:
	rotation += spin_speed * delta  # efeito a girar

func _on_body_entered(body: Node2D) -> void:  
	if body.is_in_group("player"):
		GameState.add_resource(resource_type, amount)
		queue_free()
