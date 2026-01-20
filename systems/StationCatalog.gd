extends Node
class_name StationCatalog

const STATIONS: Dictionary = {
	"station_alpha": {
		"title": "Estacao Alfa",
		"prompt": "E - Estacao Alfa",
		"color": Color(0.35, 0.7, 1.0),
		"trades": {
			"scrap_to_mineral": {"give": {"scrap": 10}, "receive": {"mineral": 1}},
			"mineral_to_scrap": {"give": {"mineral": 1}, "receive": {"scrap": 8}},
		},
		"artifact_part_cost": {"scrap": 80, "mineral": 30},
		"offered_quests": ["kill_15_basic"],
	},
	"station_beta": {
		"title": "Outpost Beta",
		"prompt": "E - Outpost Beta",
		"color": Color(0.7, 0.35, 1.0),
		"trades": {
			"scrap_to_mineral": {"give": {"scrap": 8}, "receive": {"mineral": 1}},
			"mineral_to_scrap": {"give": {"mineral": 1}, "receive": {"scrap": 10}},
		},
		"artifact_part_cost": {"scrap": 60, "mineral": 40},
		"offered_quests": ["kill_10_sniper"],
	},
	"station_gamma": {
		"title": "Base Gamma",
		"prompt": "E - Base Gamma",
		"color": Color(1.0, 0.55, 0.25),
		"trades": {
			"scrap_to_mineral": {"give": {"scrap": 12}, "receive": {"mineral": 2}},
			"mineral_to_scrap": {"give": {"mineral": 2}, "receive": {"scrap": 15}},
		},
		"artifact_part_cost": {"scrap": 110, "mineral": 55},
		"offered_quests": ["kill_5_tank"],
	},
	"station_delta": {
		"title": "Mercador Delta",
		"prompt": "E - Mercador Delta",
		"color": Color(0.25, 1.0, 0.65),
		"trades": {
			"scrap_to_mineral": {"give": {"scrap": 14}, "receive": {"mineral": 2}},
			"mineral_to_scrap": {"give": {"mineral": 1}, "receive": {"scrap": 6}},
		},
		"artifact_part_cost": {"scrap": 95, "mineral": 20},
		"offered_quests": ["tavern_bandit"],
	},
	"station_epsilon": {
		"title": "Refugio Epsilon",
		"prompt": "E - Refugio Epsilon",
		"color": Color(1.0, 0.85, 0.25),
		"trades": {
			"scrap_to_mineral": {"give": {"scrap": 6}, "receive": {"mineral": 1}},
			"mineral_to_scrap": {"give": {"mineral": 2}, "receive": {"scrap": 14}},
		},
		"artifact_part_cost": {"scrap": 70, "mineral": 45},
		"offered_quests": ["tavern_bandit"],
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

static func get_offered_quests(station_id: String) -> Array:
	return get_station_def(station_id).get("offered_quests", []) as Array
