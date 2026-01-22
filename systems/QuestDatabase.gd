extends RefCounted
class_name QuestDatabase

const QUEST_KILL_15_BASIC := "kill_15_basic"
const QUEST_KILL_20_BASIC_SCRAP := "kill_20_basic_scrap"
const QUEST_KILL_8_SNIPER_ZONE1 := "kill_8_sniper_zone1"
const QUEST_KILL_10_SNIPER := "kill_10_sniper"
const QUEST_KILL_25_SNIPER_AMETISTA := "kill_25_sniper_ametista"
const QUEST_KILL_5_TANK := "kill_5_tank"
const QUEST_KILL_12_TANK_AMETISTA := "kill_12_tank_ametista"
const QUEST_KILL_30_MIXED := "kill_30_mixed"
const QUEST_COLLECT_50_SCRAP := "collect_50_scrap"
const QUEST_COLLECT_100_MINERAL := "collect_100_mineral"
const QUEST_VACUUM_PART := "vacuum_part"
const QUEST_REVERSE_THRUSTER_PART_QUEST := "reverse_thruster_part_quest"
const QUEST_SIDE_DASH_MAP := "side_dash_map"
const QUEST_AUTO_REGEN_PART_QUEST := "auto_regen_part_quest"
const QUEST_AUX_SHIP_PART := "aux_ship_part"
const QUEST_AUX_SHIP_MAP := "aux_ship_map"
const QUEST_MINE_4_AMETISTA := "mine_4_ametista"
const QUEST_DEFEAT_HUMANS := "defeat_humans"
const QUEST_DISCOVER_2_STATIONS := "discover_2_stations"
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
	QUEST_KILL_20_BASIC_SCRAP: {
		"title": "Limpeza Total",
		"description": "Mata 20 inimigos basicos para limpar o setor.",
		"enemy_id": "basic",
		"goal": 20,
		"giver_station_id": "station_alpha",
		"reward": {"scrap": 80, "mineral": 30},
	},
	QUEST_KILL_8_SNIPER_ZONE1: {
		"title": "Atiradores de Elite",
		"description": "Mata 8 inimigos sniper. Desafio para iniciantes.",
		"enemy_id": "sniper",
		"goal": 8,
		"giver_station_id": "station_delta",
		"reward": {"scrap": 70, "mineral": 40},
	},
	QUEST_KILL_10_SNIPER: {
		"title": "Atiradores",
		"description": "Mata 10 inimigos sniper.",
		"enemy_id": "sniper",
		"goal": 10,
		"reward": {"scrap": 50, "mineral": 45},
	},
	QUEST_KILL_25_SNIPER_AMETISTA: {
		"title": "Caçador de Elite",
		"description": "Mata 25 inimigos sniper. Recompensa especial com ametista.",
		"enemy_id": "sniper",
		"goal": 25,
		"giver_station_id": "station_beta",
		"reward": {"scrap": 120, "mineral": 80, "ametista": 1},
	},
	QUEST_KILL_5_TANK: {
		"title": "Blindados",
		"description": "Mata 5 inimigos tank.",
		"enemy_id": "tank",
		"goal": 5,
		"reward": {"scrap": 80, "mineral": 60},
	},
	QUEST_KILL_12_TANK_AMETISTA: {
		"title": "Destruidor de Blindados",
		"description": "Mata 12 inimigos tank. Recompensa especial com ametista.",
		"enemy_id": "tank",
		"goal": 12,
		"giver_station_id": "station_gamma",
		"reward": {"scrap": 150, "mineral": 100, "ametista": 1},
	},
	QUEST_KILL_30_MIXED: {
		"title": "Variedade Letal",
		"description": "Mata 30 inimigos de qualquer tipo (basicos, snipers ou tanks).",
		"enemy_id": "any",
		"goal": 30,
		"giver_station_id": "station_zeta",
		"reward": {"scrap": 140, "mineral": 90},
	},
	QUEST_COLLECT_50_SCRAP: {
		"title": "Reciclagem",
		"description": "Coleta 50 scrap de qualquer fonte.",
		"resource_type": "scrap",
		"goal": 50,
		"giver_station_id": "station_alpha",
		"reward": {"mineral": 30},
		"consumable_reward": {"repair_kit": 1},
	},
	QUEST_COLLECT_100_MINERAL: {
		"title": "Mineração Intensiva",
		"description": "Coleta 100 mineral de qualquer fonte.",
		"resource_type": "mineral",
		"goal": 100,
		"giver_station_id": "station_beta",
		"reward": {"scrap": 200, "ametista": 1},
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
	QUEST_REVERSE_THRUSTER_PART_QUEST: {
		"title": "Peca do Propulsor",
		"description": "Uma peca rara do Reverse Thruster foi encontrada. Mata 12 inimigos basicos e volta para receber a peca.",
		"enemy_id": "basic",
		"goal": 12,
		"giver_station_id": "station_delta",
		"reward": {"scrap": 50},
		"artifact_parts_reward": {"reverse_thruster": 1},
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
	QUEST_AUTO_REGEN_PART_QUEST: {
		"title": "Componente de Regeneração",
		"description": "Um componente raro de regeneração foi encontrado. Mata 20 inimigos (qualquer tipo) e volta para receber a peca.",
		"enemy_id": "any",
		"goal": 20,
		"giver_station_id": "station_gamma",
		"reward": {"scrap": 80, "mineral": 40},
		"artifact_parts_reward": {"auto_regen": 1},
	},
	QUEST_MINE_4_AMETISTA: {
		"title": "Minerio Especial",
		"description": "Usa a Broca de Mineracao para apanhar 4 ametistas em cometas especiais. Depois volta ao Posto Kappa.",
		"resource_type": "ametista",
		"goal": 4,
		"giver_station_id": "station_kappa",
		"reward": {"scrap": 80},
		"discover_station_reward": "station_beta",
	},
	QUEST_DEFEAT_HUMANS: {
		"title": "Derrotar os Humanos",
		"description": "Achas que estas preparado para enfrentar os Humanos? Chama a patrulha e derrota o lider.",
		"goal": 1,
		"giver_station_id": "station_kappa",
		"reward": {"scrap": 160, "mineral": 60},
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
	QUEST_DISCOVER_2_STATIONS: {
		"title": "Explorador",
		"description": "Descobre 2 estações novas interagindo com elas pela primeira vez.",
		"goal": 2,
		"giver_station_id": "station_epsilon",
		"reward": {"scrap": 100},
		"map_reward": "random_station",
	},
}

const NPC_QUEST_POOLS := {
	"scavenger": [QUEST_KILL_15_BASIC, QUEST_KILL_20_BASIC_SCRAP, QUEST_VACUUM_PART, QUEST_COLLECT_50_SCRAP, QUEST_AUTO_REGEN_PART_QUEST],
	"marksman": [QUEST_KILL_10_SNIPER, QUEST_KILL_8_SNIPER_ZONE1, QUEST_KILL_25_SNIPER_AMETISTA, QUEST_SIDE_DASH_MAP, QUEST_AUX_SHIP_PART],
	"bruiser": [],  # Removido QUEST_KILL_5_TANK - tanks não existem na Zona 1 onde bruiser está
	"bounty": [QUEST_KILL_15_BASIC, QUEST_KILL_10_SNIPER, QUEST_KILL_5_TANK, QUEST_AUX_SHIP_MAP, QUEST_REVERSE_THRUSTER_PART_QUEST, QUEST_DISCOVER_2_STATIONS],
	"miner": [QUEST_MINE_4_AMETISTA, QUEST_DEFEAT_HUMANS, QUEST_COLLECT_100_MINERAL],
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
