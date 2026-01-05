extends Node

signal state_changed

const SAVE_PATH := "user://save.json"
const SAVE_VERSION := 1

const BASE_PLAYER_MAX_HEALTH := 100
const BASE_FIRE_INTERVAL := 0.2
const BASE_ACCELERATION := 700.0
const BASE_MAX_SPEED := 500.0

var player_max_health: int = BASE_PLAYER_MAX_HEALTH
var player_health: int = BASE_PLAYER_MAX_HEALTH

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

func damage_player(amount: int) -> void:
	player_health = max(player_health - amount, 0)
	emit_signal("state_changed")
	_queue_save()

func heal_player(amount: int) -> void:
	player_health = min(player_health + amount, player_max_health)
	emit_signal("state_changed")
	_queue_save()

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
			return "+10 HP m\\u00e1ximo por n\\u00edvel."
		"blaster":
			return "Dispara mais r\\u00e1pido (reduz o intervalo entre tiros)."
		"engine":
			return "Mais acelera\\u00e7\\u00e3o (+12% por n\\u00edvel)."
		"thrusters":
			return "Mais velocidade m\\u00e1xima (+10% por n\\u00edvel)."
		"magnet":
			return "Aumenta o magnet dos drops (+20% range e +15% speed por n\\u00edvel)."

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
		# Recompensa simples (ajusta quando tiveres balanceamento)
		resources["scrap"] = int(resources.get("scrap", 0)) + 25
		resources["mineral"] = int(resources.get("mineral", 0)) + 25

	emit_signal("state_changed")
	_queue_save()

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
	_recalculate_player_stats()

func _apply_defaults() -> void:
	resources = {
		"scrap": 0,
		"mineral": 0,
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
	_recalculate_player_stats()
	player_health = player_max_health

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
