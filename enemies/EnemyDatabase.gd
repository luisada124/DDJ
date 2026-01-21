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

static func apply_to(enemy: Node, enemy_id: String, difficulty_multiplier: float = 1.0) -> void:
	var data := get_data(enemy_id)
	if data == null:
		return

	var diff: float = difficulty_multiplier
	if diff < 0.25:
		diff = 0.25

	var speed_mult: float = float(pow(diff, 0.25)) # aumenta pouco a velocidade

	enemy.set("move_speed", data.move_speed * speed_mult * 0.85)
	enemy.set("desired_distance", data.desired_distance)
	enemy.set("distance_tolerance", data.distance_tolerance)
	enemy.set("chase_range", data.chase_range)

	enemy.set("max_health", int(round(data.max_health * diff)))
	enemy.set("contact_damage", int(round(data.contact_damage * diff)))

	var fire_factor: float = 1.0 + 0.25 * (diff - 1.0) # mais diff = dispara mais rápido
	if fire_factor < 0.1:
		fire_factor = 0.1

	var fire_interval: float = data.fire_interval / fire_factor
	if fire_interval < 0.12:
		fire_interval = 0.12

	enemy.set("fire_interval", fire_interval)
	enemy.set("laser_damage", int(round(data.laser_damage * diff)))

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
