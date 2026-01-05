extends Node2D

@export var explosion_radius: float = 80.0
@export var explosion_damage: int = 999

func _ready() -> void:
	$AnimationPlayer.play("explosion")

	# create temporary Area2D to detect nearby comets and apply damage/explode
	var area := Area2D.new()
	var cs := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = explosion_radius
	cs.shape = shape
	area.add_child(cs)
	add_child(area)
	area.monitoring = true
	# match masks so it can detect comets (comet.tscn uses collision_mask = 13)
	area.collision_mask = 13

	# wait one physics frame so overlaps are populated
	await get_tree().process_frame

	# use a broad mask so nearby comets on any layer are detected
	area.collision_mask = 0xFFFFFFFF

	for body in area.get_overlapping_bodies():
		if body is Node and body.is_in_group("comet"):
			if body.has_method("take_damage"):
				body.take_damage(explosion_damage)
			elif body.has_method("explode"):
				body.explode()

	area.queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explosion":
		queue_free()
