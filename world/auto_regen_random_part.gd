extends "res://pickups/artifact_part.gd"

@export var part_index: int = 1 # 1 ou 2
@export var bounds_local: Rect2 = Rect2(-3072, -3072, 6144, 6144)
@export var margin: float = 250.0

func _ready() -> void:
	artifact_id = "auto_regen"
	show_on_minimap = false

	if _is_collected() or GameState.has_artifact("auto_regen"):
		queue_free()
		return

	_ensure_position()
	super()
	call_deferred("_refresh_world_marker")

func _process(delta: float) -> void:
	if _is_map_unlocked_for_this_part() and not _is_collected():
		_set_world_marker(global_position)
	super(delta)

func _refresh_world_marker() -> void:
	if not is_inside_tree():
		return
	_set_world_marker(global_position)

func _ensure_position() -> void:
	var stored := _get_stored_local()
	if stored != Vector2.ZERO:
		position = stored
		return

	var r: Rect2 = bounds_local.grow(-margin)
	var x: float = randf_range(r.position.x, r.position.x + r.size.x)
	var y: float = randf_range(r.position.y, r.position.y + r.size.y)
	position = Vector2(x, y)
	_set_stored_local(position)
	GameState.queue_save()

func _on_body_entered(body: Node2D) -> void:
	if body != null and body.is_in_group("player"):
		_set_collected(true)
		_set_world_marker(Vector2.ZERO)
		GameState.queue_save()
	super(body)

func _is_map_unlocked_for_this_part() -> bool:
	if part_index == 1:
		return GameState.auto_regen_map_zone1_bought
	return GameState.auto_regen_map_zone2_bought

func _get_stored_local() -> Vector2:
	if part_index == 1:
		return GameState.auto_regen_part1_local
	return GameState.auto_regen_part2_local

func _set_stored_local(v: Vector2) -> void:
	if part_index == 1:
		GameState.auto_regen_part1_local = v
	else:
		GameState.auto_regen_part2_local = v

func _is_collected() -> bool:
	if part_index == 1:
		return GameState.auto_regen_part1_collected
	return GameState.auto_regen_part2_collected

func _set_collected(v: bool) -> void:
	if part_index == 1:
		GameState.auto_regen_part1_collected = v
	else:
		GameState.auto_regen_part2_collected = v

func _set_world_marker(v: Vector2) -> void:
	if part_index == 1:
		GameState.auto_regen_part1_world = v
	else:
		GameState.auto_regen_part2_world = v

