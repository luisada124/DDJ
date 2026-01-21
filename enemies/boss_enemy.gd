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

func _shoot(dir_to_player: Vector2) -> void:
	if laser_scene == null:
		laser_scene = load("res://player/lasers/Laser.tscn")
	if laser_scene == null:
		return

	var dir := dir_to_player.normalized()
	var perp := Vector2(-dir.y, dir.x)
	var offsets := [perp * 16.0, -perp * 16.0]
	for offset in offsets:
		var laser := laser_scene.instantiate()
		laser.global_position = global_position + dir * 40.0 + offset
		laser.direction = dir
		laser.rotation = dir.angle() - Vector2.UP.angle()
		laser.set("damage", laser_damage)
		laser.from_player = false

		var root := get_tree().current_scene
		if root != null:
			root.call_deferred("add_child", laser)
