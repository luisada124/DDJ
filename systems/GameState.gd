extends Node

signal state_changed

const SAVE_PATH := "user://save.json"
const SAVE_VERSION := 1

const BASE_PLAYER_MAX_HEALTH := 100
const BASE_ALIEN_MAX_HEALTH := 50
const BASE_FIRE_INTERVAL := 0.2
const BASE_ACCELERATION := 700.0
const BASE_MAX_SPEED := 500.0

var player_max_health: int = BASE_PLAYER_MAX_HEALTH
var player_health: int = BASE_PLAYER_MAX_HEALTH

var alien_max_health: int = BASE_ALIEN_MAX_HEALTH
var alien_health: int = BASE_ALIEN_MAX_HEALTH

var resources := {
	"scrap": 0,
	"mineral": 0,
}

var upgrades := {
	"hull": 0,      # +HP max
	"blaster": 0,   # mais fire rate (menos intervalo)
	"engine": 0,    # mais aceleração
	"thrusters": 0, # mais velocidade max
	"magnet": 0,    # maior range/velocidade do magnet
}

const ARTIFACT_PARTS_REQUIRED := 4
var artifact_parts_collected: int = 0
var artifact_completed: bool = false

var current_zone_id: String = "outer"
var unlocked_zones: PackedStringArray = PackedStringArray(["outer"])

# Runtime data (nao vai para o save): usado pelo minimapa/POIs.
var zone_bounds_world: Rect2 = Rect2(-512, -512, 1024, 1024)
var zone_pois_world: Array = []

const UPGRADE_DEFS := {
	"hull": {
		"title": "Hull",
		"description": "+10 HP máximo por nível.",
		"max_level": 10,
		"base_cost": {"scrap": 10, "mineral": 0},
		"growth": 1.35,
	},
	"blaster": {
		"title": "Blaster",
		"description": "Dispara mais rápido (reduz o intervalo entre tiros).",
		"max_level": 10,
		"base_cost": {"scrap": 12, "mineral": 2},
		"growth": 1.35,
	},
	"engine": {
		"title": "Engine",
		"description": "Mais aceleração (+12% por nível).",
		"max_level": 10,
		"base_cost": {"scrap": 14, "mineral": 4},
		"growth": 1.35,
	},
	"thrusters": {
		"title": "Thrusters",
		"description": "Mais velocidade máxima (+10% por nível).",
		"max_level": 10,
		"base_cost": {"scrap": 14, "mineral": 4},
		"growth": 1.35,
	},
	"magnet": {
		"title": "Magnet",
		"description": "Aumenta o magnet dos drops (+20% range e +15% speed por nível).",
		"max_level": 10,
		"base_cost": {"scrap": 8, "mineral": 6},
		"growth": 1.35,
	},
}

var _save_queued := false

func _ready() -> void:
	randomize()
	load_game()
	emit_signal("state_changed")

func add_resource(type: String, amount: int) -> void:
	if not resources.has(type):
		resources[type] = 0
	resources[type] += amount
	print(type, " =", resources[type])
	emit_signal("state_changed")
	_queue_save()

func try_exchange(give_type: String, give_amount: int, receive_type: String, receive_amount: int) -> bool:
	if give_amount <= 0 or receive_amount <= 0:
		return false

	var have := int(resources.get(give_type, 0))
	if have < give_amount:
		return false

	resources[give_type] = have - give_amount
	resources[receive_type] = int(resources.get(receive_type, 0)) + receive_amount
	emit_signal("state_changed")
	_queue_save()
	return true

func try_buy_artifact_part(cost: Dictionary) -> bool:
	if artifact_completed:
		return false
	if artifact_parts_collected >= ARTIFACT_PARTS_REQUIRED:
		return false
	if not can_afford(cost):
		return false

	for res_type in cost.keys():
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type])

	collect_artifact_part()
	return true

func damage_player(amount: int) -> void:
	player_health = max(player_health - amount, 0)
	emit_signal("state_changed")
	_queue_save()

func heal_player(amount: int) -> void:
	player_health = min(player_health + amount, player_max_health)
	emit_signal("state_changed")
	_queue_save()

func reset_alien_health() -> void:
	alien_health = alien_max_health
	emit_signal("state_changed")

func damage_alien(amount: int) -> void:
	alien_health = max(alien_health - amount, 0)
	emit_signal("state_changed")

func heal_alien(amount: int) -> void:
	alien_health = min(alien_health + amount, alien_max_health)
	emit_signal("state_changed")

func get_fire_interval() -> float:
	var level := get_upgrade_level("blaster")
	return max(0.06, BASE_FIRE_INTERVAL * pow(0.92, level))

func get_acceleration() -> float:
	var level := get_upgrade_level("engine")
	return BASE_ACCELERATION * (1.0 + 0.12 * level)

func get_max_speed() -> float:
	var level := get_upgrade_level("thrusters")
	return BASE_MAX_SPEED * (1.0 + 0.10 * level)

func get_pickup_magnet_range_multiplier() -> float:
	var level := get_upgrade_level("magnet")
	return 1.0 + 0.20 * level

func get_pickup_magnet_speed_multiplier() -> float:
	var level := get_upgrade_level("magnet")
	return 1.0 + 0.15 * level

func get_upgrade_level(upgrade_id: String) -> int:
	return int(upgrades.get(upgrade_id, 0))

func get_upgrade_max_level(upgrade_id: String) -> int:
	var def = UPGRADE_DEFS.get(upgrade_id)
	if def == null:
		return 0
	return int(def.get("max_level", 0))

func get_upgrade_title(upgrade_id: String) -> String:
	var def = UPGRADE_DEFS.get(upgrade_id)
	if def == null:
		return upgrade_id
	return str(def.get("title", upgrade_id))

func get_upgrade_description(upgrade_id: String) -> String:
	match upgrade_id:
		"hull":
			return "+10 HP máximo por nível."
		"blaster":
			return "Dispara mais rápido (reduz o intervalo entre tiros)."
		"engine":
			return "Mais aceleração (+12% por nível)."
		"thrusters":
			return "Mais velocidade máxima (+10% por nível)."
		"magnet":
			return "Aumenta o magnet dos drops (+20% range e +15% speed por nível)."

	var def = UPGRADE_DEFS.get(upgrade_id)
	if def == null:
		return ""
	return str(def.get("description", ""))

func get_upgrade_cost(upgrade_id: String) -> Dictionary:
	var def = UPGRADE_DEFS.get(upgrade_id)
	if def == null:
		return {}

	var base_cost: Dictionary = def.get("base_cost", {})
	var growth: float = float(def.get("growth", 1.0))
	var level := get_upgrade_level(upgrade_id)

	var cost := {}
	for res_type in base_cost.keys():
		var base_amount := int(base_cost[res_type])
		var scaled := int(ceil(base_amount * pow(growth, level)))
		cost[res_type] = max(scaled, 0)
	return cost

func can_afford(cost: Dictionary) -> bool:
	for res_type in cost.keys():
		if int(resources.get(res_type, 0)) < int(cost[res_type]):
			return false
	return true

func buy_upgrade(upgrade_id: String) -> bool:
	var max_level := get_upgrade_max_level(upgrade_id)
	if max_level <= 0:
		return false

	var level := get_upgrade_level(upgrade_id)
	if level >= max_level:
		return false

	var cost := get_upgrade_cost(upgrade_id)
	if not can_afford(cost):
		return false

	for res_type in cost.keys():
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type])

	upgrades[upgrade_id] = level + 1
	_recalculate_player_stats()
	emit_signal("state_changed")
	_queue_save()
	return true

func collect_artifact_part() -> void:
	if artifact_completed:
		return

	artifact_parts_collected = min(artifact_parts_collected + 1, ARTIFACT_PARTS_REQUIRED)
	if artifact_parts_collected >= ARTIFACT_PARTS_REQUIRED:
		artifact_completed = true
		resources["artifact"] = int(resources.get("artifact", 0)) + 1
		# Recompensa simples (ajusta quando tiveres balanceamento)
		resources["scrap"] = int(resources.get("scrap", 0)) + 25
		resources["mineral"] = int(resources.get("mineral", 0)) + 25

	_recalculate_zone_unlocks()
	emit_signal("state_changed")
	_queue_save()

func can_access_zone(zone_id: String) -> bool:
	if not ZoneCatalog.is_valid_zone(zone_id):
		return false

	if unlocked_zones.has(zone_id):
		return true

	var required_parts := ZoneCatalog.get_required_artifact_parts(zone_id)
	return artifact_parts_collected >= required_parts

func set_current_zone(zone_id: String) -> void:
	if not can_access_zone(zone_id):
		return
	current_zone_id = zone_id
	emit_signal("state_changed")
	_queue_save()

func set_zone_runtime_data(bounds_world: Rect2, pois_world: Array) -> void:
	zone_bounds_world = bounds_world
	zone_pois_world = pois_world
	emit_signal("state_changed")

func reset_save() -> void:
	_apply_defaults()
	save_game()
	emit_signal("state_changed")

func save_game() -> void:
	var data := {
		"version": SAVE_VERSION,
		"resources": resources,
		"upgrades": upgrades,
		"player_health": player_health,
		"artifact_parts_collected": artifact_parts_collected,
		"artifact_completed": artifact_completed,
		"current_zone_id": current_zone_id,
		"unlocked_zones": unlocked_zones,
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(data))

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_apply_defaults()
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		_apply_defaults()
		return

	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		_apply_defaults()
		return

	var data: Dictionary = parsed
	var version := int(data.get("version", 0))
	if version != SAVE_VERSION:
		_apply_defaults()
		return

	_apply_defaults()

	var loaded_resources = data.get("resources")
	if typeof(loaded_resources) == TYPE_DICTIONARY:
		for res_type in (loaded_resources as Dictionary).keys():
			resources[res_type] = int(loaded_resources[res_type])

	var loaded_upgrades = data.get("upgrades")
	if typeof(loaded_upgrades) == TYPE_DICTIONARY:
		for upgrade_id in (loaded_upgrades as Dictionary).keys():
			upgrades[upgrade_id] = int(loaded_upgrades[upgrade_id])

	player_health = int(data.get("player_health", player_max_health))
	artifact_parts_collected = int(data.get("artifact_parts_collected", 0))
	artifact_completed = bool(data.get("artifact_completed", false))
	current_zone_id = str(data.get("current_zone_id", "outer"))

	var loaded_unlocked = data.get("unlocked_zones")
	if typeof(loaded_unlocked) == TYPE_ARRAY:
		unlocked_zones = PackedStringArray(loaded_unlocked)
	elif typeof(loaded_unlocked) == TYPE_PACKED_STRING_ARRAY:
		unlocked_zones = loaded_unlocked
	else:
		unlocked_zones = PackedStringArray(["outer"])

	_recalculate_zone_unlocks()
	if not can_access_zone(current_zone_id):
		current_zone_id = "outer"
	_recalculate_player_stats()

func _apply_defaults() -> void:
	resources = {
		"scrap": 0,
		"mineral": 0,
		"artifact": 0,
	}
	upgrades = {
		"hull": 0,
		"blaster": 0,
		"engine": 0,
		"thrusters": 0,
		"magnet": 0,
	}
	artifact_parts_collected = 0
	artifact_completed = false
	current_zone_id = "outer"
	unlocked_zones = PackedStringArray(["outer"])
	_recalculate_player_stats()
	player_health = player_max_health
	alien_max_health = BASE_ALIEN_MAX_HEALTH
	alien_health = alien_max_health

func _recalculate_zone_unlocks() -> void:
	# Base: sempre podes ir para a zona exterior.
	if not unlocked_zones.has("outer"):
		unlocked_zones.append("outer")

	for zone_id in ZoneCatalog.get_zone_ids_sorted_outer_to_core():
		var required_parts := ZoneCatalog.get_required_artifact_parts(zone_id)
		if artifact_parts_collected >= required_parts and not unlocked_zones.has(zone_id):
			unlocked_zones.append(zone_id)

func _recalculate_player_stats() -> void:
	player_max_health = BASE_PLAYER_MAX_HEALTH + get_upgrade_level("hull") * 10
	player_health = clamp(player_health, 0, player_max_health)

func _queue_save() -> void:
	if _save_queued:
		return
	_save_queued = true
	call_deferred("_flush_save")

func _flush_save() -> void:
	_save_queued = false
	save_game()
