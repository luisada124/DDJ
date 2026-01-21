extends Node
class_name StationCatalog

const QuestDatabase := preload("res://systems/QuestDatabase.gd")

const STATIONS: Dictionary = {
	"station_alpha": {
		"title": "Estacao Alfa",
		"prompt": "E - Estacao Alfa",
		"color": Color(0.35, 0.7, 1.0),
		"tavern": {
			"base_hi_score": 70,
			"reward": {"scrap": 40},
		},
		"npcs": [
			{"id": "glip", "name": "Glip-Glop", "type": "scavenger"},
			{"id": "zorbo", "name": "Zorbo o Pegajoso", "type": "bruiser"},
			{"id": "mnem", "name": "Mnem-8", "type": "bounty"},
		],
		"trades": {
			"scrap_to_mineral": {"give": {"scrap": 10}, "receive": {"mineral": 1}},
			"mineral_to_scrap": {"give": {"mineral": 1}, "receive": {"scrap": 8}},
		},
		"vault_cost": {"scrap": 60, "mineral": 25},
		"artifact_part_cost": {"scrap": 80, "mineral": 30},
		"offered_quests": ["kill_15_basic"],
	},
	"station_beta": {
		"title": "Outpost Beta",
		"prompt": "E - Outpost Beta",
		"color": Color(0.7, 0.35, 1.0),
		"tavern": {
			"base_hi_score": 100,
			"reward": {"scrap": 60},
		},
		"npcs": [
			{"id": "bloop", "name": "Bloop", "type": "scavenger"},
			{"id": "krrth", "name": "Krr'th", "type": "marksman"},
			{"id": "snee", "name": "Snee-Snack", "type": "bounty"},
		],
		"trades": {
			"scrap_to_mineral": {"give": {"scrap": 8}, "receive": {"mineral": 1}},
			"mineral_to_scrap": {"give": {"mineral": 1}, "receive": {"scrap": 10}},
			"ametista_to_mineral": {"give": {"ametista": 1}, "receive": {"mineral": 30}},
			"ametista_to_scrap": {"give": {"ametista": 1}, "receive": {"scrap": 45}},
		},
		"vault_cost": {"scrap": 80, "mineral": 45},
		"artifact_part_cost": {"scrap": 60, "mineral": 40, "ametista": 1},
		"offered_quests": ["kill_10_sniper", "kill_25_sniper_ametista"],
	},
	"station_gamma": {
		"title": "Base Gamma",
		"prompt": "E - Base Gamma",
		"color": Color(1.0, 0.55, 0.25),
		"tavern": {
			"base_hi_score": 130,
			"reward": {"scrap": 90},
		},
		"npcs": [
			{"id": "vexa", "name": "Vexa", "type": "bounty"},
			{"id": "oomu", "name": "Oomu", "type": "scavenger"},
			{"id": "rrrl", "name": "Rrrl", "type": "bruiser"},
		],
		"trades": {
			"scrap_to_mineral": {"give": {"scrap": 12}, "receive": {"mineral": 2}},
			"mineral_to_scrap": {"give": {"mineral": 2}, "receive": {"scrap": 15}},
			"ametista_to_mineral": {"give": {"ametista": 1}, "receive": {"mineral": 40}},
			"ametista_to_scrap": {"give": {"ametista": 1}, "receive": {"scrap": 60}},
		},
		"vault_cost": {"scrap": 120, "mineral": 80, "ametista": 1},
		"artifact_part_cost": {"scrap": 110, "mineral": 55, "ametista": 2},
		"offered_quests": ["kill_5_tank", "kill_12_tank_ametista"],
	},
	"station_delta": {
		"title": "Mercador Delta",
		"prompt": "E - Mercador Delta",
		"color": Color(0.25, 1.0, 0.65),
		"tavern": {
			"base_hi_score": 150,
			"reward": {"scrap": 110},
		},
		"npcs": [
			{"id": "bandit", "name": "Bandido", "type": "hunter"},
			{"id": "krrth", "name": "Krr'th", "type": "marksman"},
			{"id": "snee", "name": "Snee-Snack", "type": "scavenger"},
		],
		"trades": {
			"scrap_to_mineral": {"give": {"scrap": 14}, "receive": {"mineral": 2}},
			"mineral_to_scrap": {"give": {"mineral": 1}, "receive": {"scrap": 6}},
		},
		"vault_cost": {"scrap": 70, "mineral": 15},
		"artifact_part_cost": {"scrap": 95, "mineral": 20},
		"offered_quests": [],
	},
	"station_epsilon": {
		"title": "Refugio Epsilon",
		"prompt": "E - Refugio Epsilon",
		"color": Color(1.0, 0.85, 0.25),
		"tavern": {
			"base_hi_score": 180,
			"reward": {"scrap": 140},
		},
		"npcs": [
			{"id": "hunter", "name": "Cacador", "type": "hunter"},
			{"id": "vexa", "name": "Vexa", "type": "bounty"},
			{"id": "rrrl", "name": "Rrrl", "type": "bruiser"},
		],
		"trades": {
			"scrap_to_mineral": {"give": {"scrap": 6}, "receive": {"mineral": 1}},
			"mineral_to_scrap": {"give": {"mineral": 2}, "receive": {"scrap": 14}},
		},
		"vault_cost": {"scrap": 55, "mineral": 35},
		"artifact_part_cost": {"scrap": 70, "mineral": 45},
		"offered_quests": [],
	},
}

static func get_station_def(station_id: String) -> Dictionary:
	return STATIONS.get(station_id, {})

static func get_station_title(station_id: String) -> String:
	return str(get_station_def(station_id).get("title", station_id))

static func get_prompt(station_id: String) -> String:
	return str(get_station_def(station_id).get("prompt", "E - Estacao"))

static func get_station_color(station_id: String) -> Color:
	var def := get_station_def(station_id)
	if def.has("color"):
		return def.get("color", Color(0.35, 0.7, 1.0))
	return Color(0.35, 0.7, 1.0)

static func get_trades(station_id: String) -> Dictionary:
	return get_station_def(station_id).get("trades", {}) as Dictionary

static func get_artifact_part_cost(station_id: String) -> Dictionary:
	return get_station_def(station_id).get("artifact_part_cost", {}) as Dictionary

static func get_vault_cost(station_id: String) -> Dictionary:
	return get_station_def(station_id).get("vault_cost", {}) as Dictionary

static func get_tavern_def(station_id: String) -> Dictionary:
	return get_station_def(station_id).get("tavern", {}) as Dictionary

static func get_tavern_base_score(station_id: String) -> int:
	var def := get_tavern_def(station_id)
	return int(def.get("base_hi_score", 0))

static func get_tavern_reward(station_id: String) -> Dictionary:
	return get_tavern_def(station_id).get("reward", {}) as Dictionary

static func get_station_npcs(station_id: String) -> Array:
	return get_station_def(station_id).get("npcs", []) as Array

static func get_repair_kit_cost(_station_id: String) -> Dictionary:
	# Consumível: cura 50% do HP máximo e pode ser usado fora da estação.
	return {"scrap": 80}

static func get_ship_repair_cost(_station_id: String) -> Dictionary:
	# Reparação total (cura para HP máximo) no mecânico.
	return {"scrap": 35, "mineral": 10}

static func get_offered_quests(station_id: String) -> Array:
	var npcs: Array = get_station_npcs(station_id)
	if not npcs.is_empty():
		var quests: Array[String] = []
		var seen: Dictionary = {}
		for npc_variant in npcs:
			if typeof(npc_variant) != TYPE_DICTIONARY:
				continue
			var npc: Dictionary = npc_variant
			var npc_type := str(npc.get("type", ""))
			for quest_id_variant in QuestDatabase.get_quest_pool(npc_type):
				var quest_id := str(quest_id_variant)
				if not QuestDatabase.is_quest_available_in_station(quest_id, station_id):
					continue
				if seen.has(quest_id):
					continue
				seen[quest_id] = true
				quests.append(quest_id)
		return quests

	return get_station_def(station_id).get("offered_quests", []) as Array

static func get_station_ids_offering_quest(quest_id: String) -> Array[String]:
	var ids: Array[String] = []
	for station_id_variant in STATIONS.keys():
		var station_id := str(station_id_variant)
		var offered: Array = get_offered_quests(station_id)
		for qid_variant in offered:
			if str(qid_variant) == quest_id:
				ids.append(station_id)
				break
	return ids

static func get_station_titles_offering_quest(quest_id: String) -> String:
	var ids := get_station_ids_offering_quest(quest_id)
	if ids.is_empty():
		return "Qualquer estacao"
	var titles: Array[String] = []
	for sid in ids:
		titles.append(get_station_title(sid))
	return ", ".join(titles)
