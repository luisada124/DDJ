extends RefCounted

class_name ArtifactDatabase

const ARTIFACTS: Dictionary = {
	"vacuum": {
		"title": "Aspirador",
		"description": "Permite que a nave recolha recursos automaticamente sem sair.",
		"parts_required": 2,
	},
	"reverse_thruster": {
		"title": "Thruster Reverso",
		"description": "Permite andar para trás com a nave.",
		"parts_required": 3,
		"reverse_thrust_factor": 0.45,
	},
	"side_dash": {
		"title": "Dash Lateral",
		"description": "Dá a habilidade de fazer dash lateral (botão esquerdo/direito do rato).",
		"parts_required": 3,
		"dash_speed": 900.0,
		"dash_duration": 0.10,
		"dash_cooldown": 1.2,
	},
	"aux_ship": {
		"title": "Nave Auxiliar",
		"description": "Uma nave auxiliar que segue e ataca inimigos automaticamente.",
		"parts_required": 3,
		"fire_interval": 0.45,
		"laser_damage": 4,
		"range": 1400.0,
	},
	"mining_drill": {
		"title": "Broca de Mineracao",
		"description": "Permite extrair ametista de cometas especiais.",
		"parts_required": 1,
	},
	"auto_regen": {
		"title": "Regenerador",
		"description": "Regenera vida da nave automaticamente quando não leva dano.",
		"parts_required": 2,
		"regen_delay": 6.0,
		"regen_rate": 3.0, # HP por segundo
	},
}

static func is_valid_artifact(artifact_id: String) -> bool:
	return ARTIFACTS.has(artifact_id)

static func get_artifact_title(artifact_id: String) -> String:
	var def: Dictionary = ARTIFACTS.get(artifact_id, {})
	return str(def.get("title", artifact_id))

static func get_artifact_description(artifact_id: String) -> String:
	var def: Dictionary = ARTIFACTS.get(artifact_id, {})
	return str(def.get("description", ""))

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

static func get_aux_ship_fire_interval() -> float:
	var def: Dictionary = ARTIFACTS.get("aux_ship", {})
	return float(def.get("fire_interval", 0.45))

static func get_aux_ship_laser_damage() -> int:
	var def: Dictionary = ARTIFACTS.get("aux_ship", {})
	return int(def.get("laser_damage", 4))

static func get_aux_ship_range() -> float:
	var def: Dictionary = ARTIFACTS.get("aux_ship", {})
	return float(def.get("range", 1400.0))

static func get_regen_delay() -> float:
	var def: Dictionary = ARTIFACTS.get("auto_regen", {})
	return float(def.get("regen_delay", 6.0))

static func get_regen_rate() -> float:
	var def: Dictionary = ARTIFACTS.get("auto_regen", {})
	return float(def.get("regen_rate", 3.0))
