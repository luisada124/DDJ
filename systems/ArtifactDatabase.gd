extends RefCounted

class_name ArtifactDatabase

const ARTIFACTS: Dictionary = {
	"vacuum": {
		"title": "Aspirador",
		"parts_required": 2,
	},
	"reverse_thruster": {
		"title": "Thruster Reverso",
		"parts_required": 3,
		"reverse_thrust_factor": 0.45,
	},
	"side_dash": {
		"title": "Dash Lateral",
		"parts_required": 6,
		"dash_speed": 1100.0,
		"dash_duration": 0.12,
		"dash_cooldown": 0.6,
	},
}

static func is_valid_artifact(artifact_id: String) -> bool:
	return ARTIFACTS.has(artifact_id)

static func get_artifact_title(artifact_id: String) -> String:
	var def: Dictionary = ARTIFACTS.get(artifact_id, {})
	return str(def.get("title", artifact_id))

static func get_parts_required(artifact_id: String) -> int:
	var def: Dictionary = ARTIFACTS.get(artifact_id, {})
	return int(def.get("parts_required", 0))

static func get_reverse_thrust_factor() -> float:
	var def: Dictionary = ARTIFACTS.get("reverse_thruster", {})
	return float(def.get("reverse_thrust_factor", 0.45))

static func get_dash_speed() -> float:
	var def: Dictionary = ARTIFACTS.get("side_dash", {})
	return float(def.get("dash_speed", 1100.0))

static func get_dash_duration() -> float:
	var def: Dictionary = ARTIFACTS.get("side_dash", {})
	return float(def.get("dash_duration", 0.12))

static func get_dash_cooldown() -> float:
	var def: Dictionary = ARTIFACTS.get("side_dash", {})
	return float(def.get("dash_cooldown", 0.6))
