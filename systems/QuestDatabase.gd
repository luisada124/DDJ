extends RefCounted
class_name QuestDatabase

const QUEST_KILL_15_BASIC := "kill_15_basic"
const QUEST_KILL_10_SNIPER := "kill_10_sniper"
const QUEST_KILL_5_TANK := "kill_5_tank"
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

const NPC_QUEST_POOLS := {
	"scavenger": [QUEST_KILL_15_BASIC],
	"marksman": [QUEST_KILL_10_SNIPER],
	"bruiser": [QUEST_KILL_5_TANK],
	"bounty": [QUEST_KILL_15_BASIC, QUEST_KILL_10_SNIPER, QUEST_KILL_5_TANK],
	"hunter": [QUEST_TAVERN_BANDIT],
}

const DEFAULT_NPC_QUEST_POOL := "bounty"

static func get_quest_def(quest_id: String) -> Dictionary:
	return QUEST_DEFS.get(quest_id, {}) as Dictionary

static func get_all_quest_ids() -> Array[String]:
	var ids: Array[String] = []
	for quest_id_variant in QUEST_DEFS.keys():
		ids.append(str(quest_id_variant))
	return ids

static func get_quest_pool(npc_type: String) -> Array[String]:
	var pool: Array = NPC_QUEST_POOLS.get(npc_type, NPC_QUEST_POOLS.get(DEFAULT_NPC_QUEST_POOL, []))
	var ids: Array[String] = []
	for quest_id_variant in pool:
		ids.append(str(quest_id_variant))
	return ids

static func is_quest_available_in_station(quest_id: String, station_id: String) -> bool:
	var def := get_quest_def(quest_id)
	var giver := str(def.get("giver_station_id", ""))
	var target := str(def.get("target_station_id", ""))
	if giver.is_empty() and target.is_empty():
		return true
	return station_id == giver or station_id == target
