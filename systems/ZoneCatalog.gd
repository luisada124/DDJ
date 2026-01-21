extends Node
class_name ZoneCatalog

# Zonas em "rings": quanto menor o ring, mais perto do centro (mais dificil).
# `required_artifact_parts` usa as partes do artefacto que ja tens no `GameState`.
const ZONES: Dictionary = {
	"outer": {
		"title": "Cinturao Exterior",
		"scene": "res://world/Zone1.tscn",
		"ring": 2,
		"difficulty_multiplier": 1.0,
		"required_artifact_parts": 0,
		# Coordenadas locais da cena da zona (antes de offset/scale do ZoneManager).
		"bounds": Rect2(-3072, -3072, 6144, 6144),
		"pois": [
			{
				"id": "artifact_enemy",
				"type": "artifact",
				"title": "Artefacto (inimigos)",
				"pos": Vector2(-700, -650),
			},
			{
				"id": "artifact_trader",
				"type": "trader",
				"title": "Trader (troca)",
				"pos": Vector2(-700, 650),
			},
		],
	},
	"mid": {
		"title": "Zona Intermedia",
		"scene": "res://world/Zone2.tscn",
		"ring": 1,
		"difficulty_multiplier": 1.5,
		"required_artifact_parts": 1,
		"bounds": Rect2(-3072, -3072, 6144, 6144),
		"pois": [
			{
				"id": "artifact_enemy",
				"type": "artifact",
				"title": "Artefacto (inimigos)",
				"pos": Vector2(-700, -650),
			},
			{
				"id": "artifact_trader",
				"type": "trader",
				"title": "Trader (troca)",
				"pos": Vector2(-700, 650),
			},
		],
	},
	"core": {
		"title": "Nucleo (Centro)",
		"scene": "res://world/Zone3.tscn",
		"ring": 0,
		"difficulty_multiplier": 2.2,
		"required_artifact_parts": 2,
		"bounds": Rect2(-3072, -3072, 6144, 6144),
		"pois": [
			{
				"id": "artifact_enemy",
				"type": "artifact",
				"title": "Artefacto (inimigos)",
				"pos": Vector2(-700, -650),
			},
			{
				"id": "artifact_trader",
				"type": "trader",
				"title": "Trader (troca)",
				"pos": Vector2(-700, 650),
			},
		],
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

static func get_zone_bounds_local(zone_id: String) -> Rect2:
	var def := get_zone_def(zone_id)
	return def.get("bounds", Rect2(-512, -512, 1024, 1024))

static func get_zone_pois_local(zone_id: String) -> Array:
	var def := get_zone_def(zone_id)
	return def.get("pois", [])

static func get_zone_ids_sorted_outer_to_core() -> Array[String]:
	var ids: Array[String] = []
	for k in ZONES.keys():
		ids.append(str(k))
	ids.sort_custom(func(a: String, b: String) -> bool:
		return int(ZONES[a].get("ring", 0)) > int(ZONES[b].get("ring", 0))
	)
	return ids
