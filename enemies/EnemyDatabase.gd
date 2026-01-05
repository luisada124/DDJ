extends RefCounted

class_name EnemyDatabase

static var _data_cache: Dictionary = {}

static func get_data(enemy_id: String) -> EnemyData:
	if _data_cache.is_empty():
		_load_defaults()

	var data := _data_cache.get(enemy_id) as EnemyData
	if data != null:
		return data

	return _data_cache.get("basic") as EnemyData

static func apply_to(enemy: Node, enemy_id: String) -> void:
	var data := get_data(enemy_id)
	if data == null:
		return

	enemy.set("move_speed", data.move_speed)
	enemy.set("desired_distance", data.desired_distance)
	enemy.set("distance_tolerance", data.distance_tolerance)
	enemy.set("chase_range", data.chase_range)

	enemy.set("max_health", data.max_health)
	enemy.set("contact_damage", data.contact_damage)

	enemy.set("fire_interval", data.fire_interval)
	enemy.set("laser_damage", data.laser_damage)

	if data.laser_scene_path != "":
		var laser_scene = load(data.laser_scene_path)
		if laser_scene is PackedScene:
			enemy.set("laser_scene", laser_scene)

	if data.pickup_scene_path != "":
		var pickup_scene = load(data.pickup_scene_path)
		if pickup_scene is PackedScene:
			enemy.set("pickup_scene", pickup_scene)

	enemy.set("min_drops", data.min_drops)
	enemy.set("max_drops", data.max_drops)
	enemy.set("mineral_drop_chance", data.mineral_drop_chance)
	enemy.set("scrap_amount", data.scrap_amount)
	enemy.set("mineral_amount", data.mineral_amount)

static func _load_defaults() -> void:
	_data_cache.clear()
	_register("basic", "res://enemies/data/basic_enemy.tres")
	_register("sniper", "res://enemies/data/sniper_enemy.tres")
	_register("tank", "res://enemies/data/tank_enemy.tres")

static func _register(enemy_id: String, path: String) -> void:
	var data = load(path)
	if data is EnemyData:
		_data_cache[enemy_id] = data
