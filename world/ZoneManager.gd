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
		z.position = zone_offset
		z.scale = zone_scale

func switch_to_zone(zone_id: String) -> void:
	if not GameState.can_access_zone(zone_id):
		return
	GameState.set_current_zone(zone_id)
	load_zone(zone_id)
