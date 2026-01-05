extends Node
class_name ZoneCatalog

# Zonas em "rings": quanto menor o ring, mais perto do centro (mais difícil).
# `required_artifact_parts` usa as partes do artefacto que já tens no `GameState`.
const ZONES: Dictionary = {
	"outer": {
		"title": "Cinturão Exterior",
		"scene": "res://world/Zone1.tscn",
		"ring": 2,
		"difficulty_multiplier": 1.0,
		"required_artifact_parts": 0,
	},
	"mid": {
		"title": "Zona Intermédia",
		"scene": "res://world/Zone2.tscn",
		"ring": 1,
		"difficulty_multiplier": 1.5,
		"required_artifact_parts": 2,
	},
	"core": {
		"title": "Núcleo (Centro)",
		"scene": "res://world/Zone3.tscn",
		"ring": 0,
		"difficulty_multiplier": 2.2,
		"required_artifact_parts": 4,
	},
}

static func is_valid_zone(zone_id: String) -> bool:
	return ZONES.has(zone_id)

static func get_zone_def(zone_id: String) -> Dictionary:
	return ZONES.get(zone_id, {})

static func get_zone_title(zone_id: String) -> String:
	var def := get_zone_def(zone_id)
	return str(def.get("title", zone_id))

static func get_zone_scene_path(zone_id: String) -> String:
	var def := get_zone_def(zone_id)
	return str(def.get("scene", ""))

static func get_required_artifact_parts(zone_id: String) -> int:
	var def := get_zone_def(zone_id)
	return int(def.get("required_artifact_parts", 0))

static func get_zone_ids_sorted_outer_to_core() -> Array[String]:
	var ids: Array[String] = []
	for k in ZONES.keys():
		ids.append(str(k))
	ids.sort_custom(func(a, b):
		return int(ZONES[a].get("ring", 0)) > int(ZONES[b].get("ring", 0))
	)
	return ids
