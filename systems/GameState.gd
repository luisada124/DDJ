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
	"ametista": 0,
}

const QUEST_KILL_15_BASIC := "kill_15_basic"
const QUEST_KILL_10_SNIPER := "kill_10_sniper"
const QUEST_KILL_5_TANK := "kill_5_tank"
const QUEST_KILL_25_SNIPER_AMETISTA := "kill_25_sniper_ametista"
const QUEST_KILL_12_TANK_AMETISTA := "kill_12_tank_ametista"
const QUEST_TAVERN_BANDIT := "tavern_bandit"
const QUEST_DEFS := {
	QUEST_KILL_15_BASIC: {
		"title": "Limpar o Setor",
		"description": "Mata 15 inimigos basicos.",
		"enemy_id": "basic",
		"goal": 15,
		"reward": {"scrap": 60, "mineral": 25},
	},
	QUEST_KILL_10_SNIPER: {
		"title": "Atiradores",
		"description": "Mata 10 inimigos sniper.",
		"enemy_id": "sniper",
		"goal": 10,
		"reward": {"scrap": 50, "mineral": 45},
	},
	QUEST_KILL_5_TANK: {
		"title": "Blindados",
		"description": "Mata 5 inimigos tank.",
		"enemy_id": "tank",
		"goal": 5,
		"reward": {"scrap": 80, "mineral": 60},
	},
	QUEST_KILL_25_SNIPER_AMETISTA: {
		"title": "Olho Roxo",
		"description": "Mata 25 inimigos sniper (missao dificil).",
		"enemy_id": "sniper",
		"goal": 25,
		"reward": {"scrap": 140, "mineral": 120, "ametista": 1},
	},
	QUEST_KILL_12_TANK_AMETISTA: {
		"title": "Quebra-Cascos",
		"description": "Mata 12 inimigos tank (missao dificil).",
		"enemy_id": "tank",
		"goal": 12,
		"reward": {"scrap": 220, "mineral": 180, "ametista": 2},
	},
	QUEST_TAVERN_BANDIT: {
		"title": "Acerto de Contas",
		"description": "Derrota o Bandido na taberna do Mercador Delta e volta ao Cacador no Refugio Epsilon para receber a recompensa.",
		"goal": 1,
		"giver_station_id": "station_epsilon",
		"target_station_id": "station_delta",
		"reward": {},
		"artifact_parts_reward": {"reverse_thruster": 3},
	},
}

var quests: Dictionary = {}

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

var artifact_parts: Dictionary = {}
var unlocked_artifacts: PackedStringArray = PackedStringArray([])

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

func accept_quest(quest_id: String) -> bool:
	if not QUEST_DEFS.has(quest_id):
		return false

	var q: Dictionary = quests.get(quest_id, {}) as Dictionary
	if q.is_empty():
		q = _make_default_quest_state()

	if bool(q.get("accepted", false)):
		return false

	q["accepted"] = true
	quests[quest_id] = q
	emit_signal("state_changed")
	_queue_save()
	return true

func record_enemy_kill(enemy_id: String) -> void:
	var changed := false
	for quest_id_variant in quests.keys():
		var quest_id := str(quest_id_variant)
		var q: Dictionary = quests.get(quest_id, {}) as Dictionary
		if not bool(q.get("accepted", false)):
			continue
		if bool(q.get("completed", false)):
			continue

		var def: Dictionary = QUEST_DEFS.get(quest_id, {}) as Dictionary
		var required_enemy_id := str(def.get("enemy_id", ""))
		if required_enemy_id.is_empty() or required_enemy_id != enemy_id:
			continue

		var goal: int = int(def.get("goal", 0))
		var progress: int = int(q.get("progress", 0))
		progress = min(progress + 1, goal)
		q["progress"] = progress
		if progress >= goal:
			q["completed"] = true
		quests[quest_id] = q
		changed = true

	if changed:
		emit_signal("state_changed")
		_queue_save()

func complete_quest(quest_id: String) -> bool:
	if not QUEST_DEFS.has(quest_id):
		return false

	var q: Dictionary = quests.get(quest_id, {}) as Dictionary
	if q.is_empty():
		q = _make_default_quest_state()

	if not bool(q.get("accepted", false)):
		return false
	if bool(q.get("completed", false)):
		return false

	var def: Dictionary = QUEST_DEFS.get(quest_id, {}) as Dictionary
	var goal: int = int(def.get("goal", 0))
	q["progress"] = goal
	q["completed"] = true
	quests[quest_id] = q

	emit_signal("state_changed")
	_queue_save()
	return true

func can_claim_quest(quest_id: String) -> bool:
	var q: Dictionary = quests.get(quest_id, {}) as Dictionary
	if q.is_empty():
		return false
	return bool(q.get("completed", false)) and not bool(q.get("claimed", false))

func claim_quest(quest_id: String) -> bool:
	if not can_claim_quest(quest_id):
		return false

	var def: Dictionary = QUEST_DEFS.get(quest_id, {}) as Dictionary
	var reward: Dictionary = def.get("reward", {}) as Dictionary
	for res_type_variant in reward.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) + int(reward[res_type])

	var artifact_reward: Dictionary = def.get("artifact_parts_reward", {}) as Dictionary
	for artifact_id_variant in artifact_reward.keys():
		var artifact_id := str(artifact_id_variant)
		var count := int(artifact_reward[artifact_id_variant])
		for _i in range(max(count, 0)):
			collect_artifact_part(artifact_id)

	var q: Dictionary = quests.get(quest_id, {}) as Dictionary
	q["claimed"] = true
	quests[quest_id] = q

	emit_signal("state_changed")
	_queue_save()
	return true

func get_quest_state(quest_id: String) -> Dictionary:
	return quests.get(quest_id, {}) as Dictionary

func _make_default_quest_state() -> Dictionary:
	return {
		"accepted": false,
		"progress": 0,
		"completed": false,
		"claimed": false,
	}

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

func has_artifact(artifact_id: String) -> bool:
	return unlocked_artifacts.has(artifact_id)

func get_artifact_parts(artifact_id: String) -> int:
	return int(artifact_parts.get(artifact_id, 0))

func is_artifact_completed(artifact_id: String) -> bool:
	if artifact_id == "relic":
		return artifact_completed
	return has_artifact(artifact_id)

func can_ship_collect_pickups() -> bool:
	return has_artifact("vacuum")

func has_reverse_thruster() -> bool:
	return has_artifact("reverse_thruster")

func has_side_dash() -> bool:
	return has_artifact("side_dash")

func get_reverse_thrust_factor() -> float:
	return ArtifactDatabase.get_reverse_thrust_factor()

func get_dash_speed() -> float:
	return ArtifactDatabase.get_dash_speed()

func get_dash_duration() -> float:
	return ArtifactDatabase.get_dash_duration()

func get_dash_cooldown() -> float:
	return ArtifactDatabase.get_dash_cooldown()

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

func collect_artifact_part(artifact_id: String = "relic") -> void:
	if artifact_id == "relic":
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
		return

	if not ArtifactDatabase.is_valid_artifact(artifact_id):
		return

	if unlocked_artifacts.has(artifact_id):
		return

	var required: int = ArtifactDatabase.get_parts_required(artifact_id)
	if required <= 0:
		return

	var current: int = int(artifact_parts.get(artifact_id, 0))
	current += 1
	if current > required:
		current = required
	artifact_parts[artifact_id] = current

	if current >= required:
		unlocked_artifacts.append(artifact_id)

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
		"quests": quests,
		"upgrades": upgrades,
		"player_health": player_health,
		"artifact_parts_collected": artifact_parts_collected,
		"artifact_completed": artifact_completed,
		"artifact_parts": artifact_parts,
		"unlocked_artifacts": unlocked_artifacts,
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

	var loaded_quests = data.get("quests")
	if typeof(loaded_quests) == TYPE_DICTIONARY:
		quests = loaded_quests

	var loaded_upgrades = data.get("upgrades")
	if typeof(loaded_upgrades) == TYPE_DICTIONARY:
		for upgrade_id in (loaded_upgrades as Dictionary).keys():
			upgrades[upgrade_id] = int(loaded_upgrades[upgrade_id])

	player_health = int(data.get("player_health", player_max_health))
	artifact_parts_collected = int(data.get("artifact_parts_collected", 0))
	artifact_completed = bool(data.get("artifact_completed", false))

	var loaded_artifact_parts = data.get("artifact_parts")
	if typeof(loaded_artifact_parts) == TYPE_DICTIONARY:
		artifact_parts.clear()
		for artifact_id in (loaded_artifact_parts as Dictionary).keys():
			artifact_parts[str(artifact_id)] = int(loaded_artifact_parts[artifact_id])

	var loaded_unlocked_artifacts = data.get("unlocked_artifacts")
	if typeof(loaded_unlocked_artifacts) == TYPE_ARRAY:
		unlocked_artifacts = PackedStringArray(loaded_unlocked_artifacts)
	elif typeof(loaded_unlocked_artifacts) == TYPE_PACKED_STRING_ARRAY:
		unlocked_artifacts = loaded_unlocked_artifacts
	else:
		unlocked_artifacts = PackedStringArray([])

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
	_ensure_quests_initialized()
	_recalculate_player_stats()

func _apply_defaults() -> void:
	resources = {
		"scrap": 0,
		"mineral": 0,
		"artifact": 0,
		"ametista": 0,
	}
	quests = {}
	_ensure_quests_initialized()
	upgrades = {
		"hull": 0,
		"blaster": 0,
		"engine": 0,
		"thrusters": 0,
		"magnet": 0,
	}
	artifact_parts_collected = 0
	artifact_completed = false
	artifact_parts = {
		"vacuum": 0,
		"reverse_thruster": 0,
	}
	unlocked_artifacts = PackedStringArray([])
	current_zone_id = "outer"
	unlocked_zones = PackedStringArray(["outer"])
	_recalculate_player_stats()
	player_health = player_max_health
	alien_max_health = BASE_ALIEN_MAX_HEALTH
	alien_health = alien_max_health

func _ensure_quests_initialized() -> void:
	if quests == null:
		quests = {}
	for quest_id_variant in QUEST_DEFS.keys():
		var quest_id := str(quest_id_variant)
		if not quests.has(quest_id):
			quests[quest_id] = _make_default_quest_state()

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
