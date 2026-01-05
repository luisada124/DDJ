extends Area2D

@export var spin_speed: float = 2.0

func _ready() -> void:
	add_to_group("artifact_part")
	if GameState.artifact_completed:
		queue_free()

func _process(delta: float) -> void:
	rotation += spin_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.collect_artifact_part()
		queue_free()

