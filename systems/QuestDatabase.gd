extends RefCounted
class_name QuestDatabase

const QUEST_KILL_15_BASIC := "kill_15_basic"
const QUEST_KILL_10_SNIPER := "kill_10_sniper"
const QUEST_KILL_5_TANK := "kill_5_tank"
const QUEST_VACUUM_PART := "vacuum_part"
const QUEST_SIDE_DASH_MAP := "side_dash_map"
const QUEST_AUX_SHIP_PART := "aux_ship_part"
const QUEST_AUX_SHIP_MAP := "aux_ship_map"
const QUEST_TAVERN_BANDIT_1 := "tavern_bandit_1"
const QUEST_TAVERN_BANDIT_2 := "tavern_bandit_2"
const QUEST_TAVERN_BANDIT_3 := "tavern_bandit_3"
const QUEST_TAVERN_BANDIT_4 := "tavern_bandit_4"
const QUEST_TAVERN_BANDIT_5 := "tavern_bandit_5"
const QUEST_BOSS_PLANET := "boss_planet"
const QUEST_TAVERN_BANDIT := QUEST_TAVERN_BANDIT_1

const BANDIT_QUESTS := [
	QUEST_TAVERN_BANDIT_1,
	QUEST_TAVERN_BANDIT_2,
	QUEST_TAVERN_BANDIT_3,
	QUEST_TAVERN_BANDIT_4,
	QUEST_TAVERN_BANDIT_5,
]

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
	QUEST_VACUUM_PART: {
		"title": "Filtro Perdido",
		"description": "O Aspirador precisa de um filtro raro. Mata 8 inimigos basicos e volta para receber a peça.",
		"enemy_id": "basic",
		"goal": 8,
		"giver_station_id": "station_alpha",
		"reward": {"scrap": 25},
		"artifact_parts_reward": {"vacuum": 1},
	},
	QUEST_SIDE_DASH_MAP: {
		"title": "Mapa do Dash",
		"description": "Um informador deixou pistas do Dash Lateral. Mata 12 inimigos basicos e volta para receberes o mapa.",
		"enemy_id": "basic",
		"goal": 12,
		"giver_station_id": "station_beta",
		"reward": {"scrap": 40},
		"artifact_parts_reward": {"side_dash": 1},
		"map_reward": "side_dash",
	},
	QUEST_AUX_SHIP_PART: {
		"title": "Drone Desligado",
		"description": "Um drone auxiliar caiu no setor. Mata 14 inimigos sniper e volta para receber uma peca da Nave Auxiliar.",
		"enemy_id": "sniper",
		"goal": 14,
		"giver_station_id": "station_zeta",
		"reward": {"scrap": 60, "mineral": 25},
		"artifact_parts_reward": {"aux_ship": 1},
	},
	QUEST_AUX_SHIP_MAP: {
		"title": "Mapa do Drone",
		"description": "Um cartografo vendeu coordenadas do drone. Mata 10 inimigos basicos e volta para receber o mapa.",
		"enemy_id": "basic",
		"goal": 10,
		"giver_station_id": "station_zeta",
		"reward": {"scrap": 35},
		"map_reward": "aux_ship",
	},
	QUEST_TAVERN_BANDIT_1: {
		"title": "Acerto de Contas I",
		"description": "Bandido 1/5: derrota-o na taberna do Mercador Delta e volta ao Cacador no Refugio Epsilon.",
		"goal": 1,
		"giver_station_id": "station_epsilon",
		"target_station_id": "station_delta",
		"reward": {},
		"qte_steps": 6,
		"qte_time": 1.2,
	},
	QUEST_TAVERN_BANDIT_2: {
		"title": "Acerto de Contas II",
		"description": "Bandido 2/5: derrota-o na taberna do Mercador Delta e volta ao Cacador.",
		"goal": 1,
		"giver_station_id": "station_epsilon",
		"target_station_id": "station_delta",
		"reward": {"scrap": 90, "mineral": 40},
		"qte_steps": 8,
		"qte_time": 1.0,
	},
	QUEST_TAVERN_BANDIT_3: {
		"title": "Acerto de Contas III",
		"description": "Bandido 3/5: derrota-o na taberna do Mercador Delta e volta ao Cacador.",
		"goal": 1,
		"giver_station_id": "station_epsilon",
		"target_station_id": "station_delta",
		"reward": {"scrap": 130, "mineral": 60},
		"qte_steps": 10,
		"qte_time": 0.9,
	},
	QUEST_TAVERN_BANDIT_4: {
		"title": "Acerto de Contas IV",
		"description": "Bandido 4/5: derrota-o na taberna do Mercador Delta e volta ao Cacador.",
		"goal": 1,
		"giver_station_id": "station_epsilon",
		"target_station_id": "station_delta",
		"reward": {"scrap": 170, "mineral": 85},
		"qte_steps": 12,
		"qte_time": 0.8,
	},
	QUEST_TAVERN_BANDIT_5: {
		"title": "Acerto de Contas V",
		"description": "Bandido 5/5: derrota-o na taberna do Mercador Delta e volta ao Cacador.",
		"goal": 1,
		"giver_station_id": "station_epsilon",
		"target_station_id": "station_delta",
		"reward": {"scrap": 220, "mineral": 110},
		"qte_steps": 14,
		"qte_time": 0.7,
	},
	QUEST_BOSS_PLANET: {
		"title": "Planeta Perdido",
		"description": "Localizacao revelada: um planeta fora do mapa. Derrota o boss que ronda o planeta e recupera a peca do artefacto.",
		"enemy_id": "boss",
		"goal": 1,
		"giver_station_id": "station_epsilon",
		"reward": {},
	},
}

const NPC_QUEST_POOLS := {
	"scavenger": [QUEST_KILL_15_BASIC, QUEST_VACUUM_PART],
	"marksman": [QUEST_KILL_10_SNIPER, QUEST_SIDE_DASH_MAP, QUEST_AUX_SHIP_PART],
	"bruiser": [QUEST_KILL_5_TANK],
	"bounty": [QUEST_KILL_15_BASIC, QUEST_KILL_10_SNIPER, QUEST_KILL_5_TANK, QUEST_AUX_SHIP_MAP],
	"hunter": [
		QUEST_TAVERN_BANDIT_1,
		QUEST_TAVERN_BANDIT_2,
		QUEST_TAVERN_BANDIT_3,
		QUEST_TAVERN_BANDIT_4,
		QUEST_TAVERN_BANDIT_5,
		QUEST_BOSS_PLANET,
	],
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
