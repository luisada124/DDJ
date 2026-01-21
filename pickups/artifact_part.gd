extends Area2D

@export var spin_speed: float = 2.0
@export var keep_visible_when_completed: bool = false
@export var artifact_id: String = "relic"
@export var show_on_minimap: bool = true

func _ready() -> void:
	if show_on_minimap:
		add_to_group("artifact_part")
	if GameState.is_artifact_completed(artifact_id) and not keep_visible_when_completed:
		queue_free()

func _process(delta: float) -> void:
	rotation += spin_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.collect_artifact_part(artifact_id)
		queue_free()
