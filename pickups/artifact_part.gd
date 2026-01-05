extends Area2D

@export var spin_speed: float = 2.0
@export var keep_visible_when_completed: bool = false

func _ready() -> void:
	add_to_group("artifact_part")
	if GameState.artifact_completed and not keep_visible_when_completed:
		queue_free()

func _process(delta: float) -> void:
	rotation += spin_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.collect_artifact_part()
		queue_free()
