extends Node2D
class_name ZoneManager

@export var default_zone_id: String = "outer"
@export var zone_offset: Vector2 = Vector2(-26, 21)
@export var zone_scale: Vector2 = Vector2(2, 2)

var _current_zone: Node = null

func _ready() -> void:
	add_to_group("zone_manager")
	var zone_id := GameState.current_zone_id
	if zone_id.is_empty():
		zone_id = default_zone_id
	load_zone(zone_id)

func load_zone(zone_id: String) -> void:
	var scene_path := ZoneCatalog.get_zone_scene_path(zone_id)
	if scene_path.is_empty():
		push_warning("Zona inválida: %s" % zone_id)
		return

	if _current_zone != null and is_instance_valid(_current_zone):
		_current_zone.queue_free()
		_current_zone = null

	var packed: PackedScene = load(scene_path)
	if packed == null:
		push_warning("Não foi possível carregar: %s" % scene_path)
		return

	_current_zone = packed.instantiate()
	add_child(_current_zone)
	if _current_zone is Node2D:
		var z := _current_zone as Node2D
		z.add_to_group("zone_root")
		z.position = zone_offset
		z.scale = zone_scale
		_push_zone_runtime_data(zone_id, z)

func _push_zone_runtime_data(zone_id: String, zone_node: Node2D) -> void:
	var bounds_local := ZoneCatalog.get_zone_bounds_local(zone_id)
	var tl := zone_node.to_global(bounds_local.position)
	var tr := zone_node.to_global(bounds_local.position + Vector2(bounds_local.size.x, 0))
	var bl := zone_node.to_global(bounds_local.position + Vector2(0, bounds_local.size.y))
	var br := zone_node.to_global(bounds_local.position + bounds_local.size)

	var min_x: float = minf(minf(tl.x, tr.x), minf(bl.x, br.x))
	var min_y: float = minf(minf(tl.y, tr.y), minf(bl.y, br.y))
	var max_x: float = maxf(maxf(tl.x, tr.x), maxf(bl.x, br.x))
	var max_y: float = maxf(maxf(tl.y, tr.y), maxf(bl.y, br.y))
	var bounds_world := Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))

	var pois_world: Array = []
	for poi in ZoneCatalog.get_zone_pois_local(zone_id):
		if typeof(poi) != TYPE_DICTIONARY:
			continue
		var d: Dictionary = poi
		var local_pos: Vector2 = d.get("pos", Vector2.ZERO)
		pois_world.append({
			"id": str(d.get("id", "")),
			"type": str(d.get("type", "")),
			"title": str(d.get("title", "")),
			"pos": zone_node.to_global(local_pos),
		})

	GameState.set_zone_runtime_data(bounds_world, pois_world)

func switch_to_zone(zone_id: String) -> void:
	if not GameState.can_access_zone(zone_id):
		return
	GameState.set_current_zone(zone_id)
	load_zone(zone_id)
