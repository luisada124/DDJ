extends "res://enemies/enemy.gd"

@export var artifact_scene: PackedScene
@export var artifact_id: String = "relic"

func die() -> void:
	_spawn_boss_artifact()
	super.die()

func _spawn_boss_artifact() -> void:
	if artifact_scene == null:
		artifact_scene = load("res://pickups/ArtifactPart.tscn")
	if artifact_scene == null:
		return

	var part := artifact_scene.instantiate()
	part.global_position = global_position
	part.set("artifact_id", artifact_id)

	var root := get_tree().current_scene
	if root != null:
		root.call_deferred("add_child", part)
