extends "res://pickups/artifact_part.gd"

@export var bounds_local: Rect2 = Rect2(-3072, -3072, 6144, 6144)
@export var margin: float = 250.0

func _ready() -> void:
	artifact_id = "reverse_thruster"
	show_on_minimap = false

	if GameState.reverse_thruster_random_part_collected or GameState.has_artifact("reverse_thruster"):
		queue_free()
		return

	_ensure_position()
	super()
	call_deferred("_refresh_world_marker")

func _process(delta: float) -> void:
	if GameState.reverse_thruster_map_bought and not GameState.reverse_thruster_random_part_collected:
		GameState.reverse_thruster_random_part_world = global_position
	super(delta)

func _refresh_world_marker() -> void:
	if not is_inside_tree():
		return
	GameState.reverse_thruster_random_part_world = global_position

func _ensure_position() -> void:
	var stored := GameState.reverse_thruster_random_part_local
	if stored != Vector2.ZERO:
		position = stored
		return

	var r: Rect2 = bounds_local.grow(-margin)
	var x: float = randf_range(r.position.x, r.position.x + r.size.x)
	var y: float = randf_range(r.position.y, r.position.y + r.size.y)
	position = Vector2(x, y)

	GameState.reverse_thruster_random_part_local = position
	GameState.queue_save()

func _on_body_entered(body: Node2D) -> void:
	if body != null and body.is_in_group("player"):
		GameState.reverse_thruster_random_part_collected = true
		GameState.reverse_thruster_random_part_world = Vector2.ZERO
		GameState.queue_save()
	super(body)

