extends RefCounted

class_name CometDatabase

static var _data_cache: Dictionary = {}
static var _id_list: Array[String] = []

static func get_data(comet_id: String) -> CometData:
	if _data_cache.is_empty():
		_load_defaults()

	var data := _data_cache.get(comet_id) as CometData
	if data != null:
		return data

	return _data_cache.get("meteor_01") as CometData

static func get_random_id() -> String:
	if _data_cache.is_empty():
		_load_defaults()

	if _id_list.is_empty():
		return "meteor_01"

	return _id_list[randi_range(0, _id_list.size() - 1)]

static func _load_defaults() -> void:
	_data_cache.clear()
	_id_list.clear()

	for i in range(1, 11):
		var id := "meteor_%02d" % i
		_register(id, "res://world/data/comets/%s.tres" % id)

static func _register(comet_id: String, path: String) -> void:
	var data = load(path)
	if data is CometData:
		_data_cache[comet_id] = data
		_id_list.append(comet_id)

