extends Node

signal state_changed
signal player_died
signal alien_died
signal speech_requested(text: String)
signal speech_requested_at(text: String, world_pos: Vector2)
signal speech_requested_timed(text: String, duration: float)
signal zone2_core_horde_requested
signal station_entered(station_id: String)
signal vacuum_broken

const SAVE_PATH := "user://save.json"
const SAVE_VERSION := 1

const BASE_PLAYER_MAX_HEALTH := 220
const BASE_ALIEN_MAX_HEALTH := 70
const BASE_FIRE_INTERVAL := 0.28
const BASE_PLAYER_LASER_DAMAGE := 6
const BASE_PLAYER_LASER_SPEED := 800.0
const BASE_AUX_LASER_SPEED := 800.0
const BASE_ACCELERATION := 470.0
const BASE_MAX_SPEED := 360.0

var player_max_health: int = BASE_PLAYER_MAX_HEALTH
var player_health: int = BASE_PLAYER_MAX_HEALTH

var alien_max_health: int = BASE_ALIEN_MAX_HEALTH
var alien_health: int = BASE_ALIEN_MAX_HEALTH

# Consumíveis (inventário).
var consumables := {
	"repair_kit": 0,
}

const MAX_REPAIR_KITS: int = 3

# Regeneração automática do "auto_regen".
var _regen_cooldown: float = 0.0
var _regen_accum: float = 0.0

# Estacoes descobertas (minimapa). No inicio: apenas Refugio Epsilon.
var discovered_station_ids: PackedStringArray = PackedStringArray([])
var alpha_station_map_bought: bool = false
var kappa_station_map_bought: bool = false
var beta_station_map_bought: bool = false
var zeta_station_map_bought: bool = false

# Zona 2 intro (Posto Kappa + broca).
var zone2_intro_station_local: Vector2 = Vector2.ZERO
var zone2_drill_given: bool = false
var mining_drill_part_local: Vector2 = Vector2.ZERO

var resources := {
	"scrap": 0,
	"mineral": 0,
	"ametista": 0,
}

# Vacuum: parte aleatória na Zona 1 + mapa que revela localização.
var vacuum_map_bought: bool = false
var vacuum_random_part_local: Vector2 = Vector2.ZERO
var vacuum_random_part_world: Vector2 = Vector2.ZERO # runtime (global), usado pelo minimapa
var vacuum_random_part_collected: bool = false
var vacuum_shop_part_bought: bool = false
var vacuum_intro_uses_left: int = 30
var vacuum_broken_once: bool = false
var vacuum_is_broken: bool = false

# Evento de transicao Zona 2 -> Zona 3 (patrulha + drop de relíquia).
var mid_core_event_triggered: bool = false
var mid_core_patrol_cleared: bool = false

# Reverse Thruster: 2 pecas em mercados (2 estacoes diferentes) + 1 peca aleatoria na Zona 1.
var reverse_thruster_map_bought: bool = false
var reverse_thruster_random_part_local: Vector2 = Vector2.ZERO
var reverse_thruster_random_part_world: Vector2 = Vector2.ZERO # runtime (global), usado pelo minimapa
var reverse_thruster_random_part_collected: bool = false
var reverse_thruster_shop_parts_bought: Dictionary = {} # station_id -> bool (compra unica por estacao)

# Side Dash: 2 pecas em mercados (2 estacoes diferentes) + 1 peca aleatoria na Zona 2, mapa por missao.
var side_dash_map_unlocked: bool = false
var side_dash_random_part_local: Vector2 = Vector2.ZERO
var side_dash_random_part_world: Vector2 = Vector2.ZERO # runtime (global), usado pelo minimapa
var side_dash_random_part_collected: bool = false
var side_dash_shop_parts_bought: Dictionary = {} # station_id -> bool (compra unica por estacao)

# Auto Regen: 2 pecas aleatorias na Zona 2 + 2 mapas (1 vendido na Zona 1, 1 vendido na Zona 2).
var auto_regen_map_zone1_bought: bool = false
var auto_regen_map_zone2_bought: bool = false
var auto_regen_part1_local: Vector2 = Vector2.ZERO
var auto_regen_part1_world: Vector2 = Vector2.ZERO # runtime
var auto_regen_part1_collected: bool = false
var auto_regen_part2_local: Vector2 = Vector2.ZERO
var auto_regen_part2_world: Vector2 = Vector2.ZERO # runtime
var auto_regen_part2_collected: bool = false

# Aux Ship: 1 peca por missao na Zona 2, 1 peca à venda, 1 peca aleatoria na Zona 2 + mapa por missao.
var aux_ship_map_unlocked: bool = false
var aux_ship_random_part_local: Vector2 = Vector2.ZERO
var aux_ship_random_part_world: Vector2 = Vector2.ZERO # runtime
var aux_ship_random_part_collected: bool = false
var aux_ship_shop_part_bought: bool = false

# Cofres por estacao: recursos guardados nao se perdem na morte.
var vault_unlocked: Dictionary = {} # station_id -> bool
var vault_resources: Dictionary = {} # station_id -> {res_type -> int}

const QuestDatabase := preload("res://systems/QuestDatabase.gd")
const QUEST_KILL_15_BASIC := QuestDatabase.QUEST_KILL_15_BASIC
const QUEST_KILL_10_SNIPER := QuestDatabase.QUEST_KILL_10_SNIPER
const QUEST_KILL_5_TANK := QuestDatabase.QUEST_KILL_5_TANK
const QUEST_TAVERN_BANDIT := QuestDatabase.QUEST_TAVERN_BANDIT
const QUEST_BOSS_PLANET := QuestDatabase.QUEST_BOSS_PLANET
const QUEST_DEFEAT_HUMANS := QuestDatabase.QUEST_DEFEAT_HUMANS
const BANDIT_QUESTS := QuestDatabase.BANDIT_QUESTS
const QUEST_DEFS := QuestDatabase.QUEST_DEFS

var quests: Dictionary = {}
var tavern_hi_scores: Dictionary = {}
var tavern_reward_claimed: Dictionary = {}
var boss_planet_resources_unlocked: bool = false
# Rastrear bosses mortos (uma vez por campanha)
var defeated_bosses: Array[String] = []

# Sistema de hints: tracking temporal
var last_quest_claim_time: float = 0.0
var last_upgrade_time: float = 0.0
var last_artifact_unlock_time: float = 0.0
var last_resource_gain_time: float = 0.0
var last_enemy_kill_time: float = 0.0
var session_start_time: float = 0.0

var upgrades := {
	"hull": 0,      # +HP max
	"blaster": 0,   # mais fire rate (menos intervalo)
	"laser_damage": 0, # mais dano do laser
	"laser_speed": 0,  # velocidade do laser
	"engine": 0,    # mais aceleração
	"thrusters": 0, # mais velocidade max
	"magnet": 0,    # maior range/velocidade do magnet
	"aux_fire_rate": 0, # nave auxiliar: fire rate
	"aux_damage": 0,    # nave auxiliar: dano
	"aux_range": 0,     # nave auxiliar: alcance
	"aux_laser_speed": 0, # nave auxiliar: velocidade do laser
}

const ARTIFACT_PARTS_REQUIRED := 2
var artifact_parts_collected: int = 0
var artifact_completed: bool = false

var artifact_parts: Dictionary = {}
var unlocked_artifacts: PackedStringArray = PackedStringArray([])

var current_zone_id: String = "outer"
var unlocked_zones: PackedStringArray = PackedStringArray(["outer"])
var visited_zones: PackedStringArray = PackedStringArray([])

# Runtime data (nao vai para o save): usado pelo minimapa/POIs.
var zone_bounds_world: Rect2 = Rect2(-512, -512, 1024, 1024)
var zone_pois_world: Array = []
var intro_pending: bool = false

const UPGRADE_DEFS := {
	"hull": {
		"title": "Casco",
		"description": "+10 HP máximo por nível.",
		"max_level": 10,
		"base_cost": {"scrap": 10, "mineral": 0},
		"growth": 1.35,
	},
	"blaster": {
		"title": "Disparador",
		"description": "Dispara mais rápido (reduz o intervalo entre tiros).",
		"max_level": 10,
		"base_cost": {"scrap": 12, "mineral": 2},
		"growth": 1.35,
	},
	"laser_damage": {
		"title": "Dano do Laser",
		"description": "Aumenta o dano do laser (+10% por nivel).",
		"max_level": 10,
		"base_cost": {"scrap": 16, "mineral": 6},
		"growth": 1.35,
	},
	"laser_speed": {
		"title": "Velocidade do Laser",
		"description": "Dispara lasers mais rapidos (+10% velocidade por nivel).",
		"max_level": 10,
		"base_cost": {"scrap": 12, "mineral": 4},
		"growth": 1.35,
	},
	"engine": {
		"title": "Motor",
		"description": "Mais aceleração (+12% por nível).",
		"max_level": 10,
		"base_cost": {"scrap": 14, "mineral": 4},
		"growth": 1.35,
	},
	"thrusters": {
		"title": "Propulsores",
		"description": "Mais velocidade máxima (+10% por nível).",
		"max_level": 10,
		"base_cost": {"scrap": 14, "mineral": 4},
		"growth": 1.35,
	},
	"magnet": {
		"title": "Iman",
		"description": "Aumenta o magnet dos drops (+20% range e +15% speed por nível).",
		"max_level": 10,
		"base_cost": {"scrap": 8, "mineral": 6},
		"growth": 1.35,
	},

	"aux_fire_rate": {
		"title": "Cadencia Aux",
		"description": "Nave auxiliar dispara mais rapido (+8% cadencia por nivel).",
		"max_level": 10,
		"base_cost": {"scrap": 10, "mineral": 8},
		"growth": 1.35,
	},
	"aux_damage": {
		"title": "Dano Aux",
		"description": "Aumenta o dano do laser da nave auxiliar (+12% por nivel).",
		"max_level": 10,
		"base_cost": {"scrap": 14, "mineral": 10},
		"growth": 1.35,
	},
	"aux_range": {
		"title": "Alcance Aux",
		"description": "Aumenta o alcance da nave auxiliar (+8% por nivel).",
		"max_level": 10,
		"base_cost": {"scrap": 12, "mineral": 8},
		"growth": 1.35,
	},
	"aux_laser_speed": {
		"title": "Velocidade Laser Aux",
		"description": "Aumenta a velocidade dos lasers da nave auxiliar (+10% por nivel).",
		"max_level": 10,
		"base_cost": {"scrap": 12, "mineral": 6},
		"growth": 1.35,
	},
}

var _save_queued := false
var _return_to_menu_queued: bool = false

func _ready() -> void:
	randomize()
	load_game()
	session_start_time = Time.get_ticks_msec() / 1000.0
	emit_signal("state_changed")

func return_to_main_menu(delay: float = 0.0) -> void:
	if _return_to_menu_queued:
		return
	_return_to_menu_queued = true
	var d: float = maxf(0.0, delay)
	call_deferred("_return_to_main_menu_deferred", d)

func _return_to_main_menu_deferred(delay: float) -> void:
	if not is_inside_tree():
		return
	if delay > 0.0:
		var t: SceneTreeTimer = get_tree().create_timer(delay)
		await t.timeout
		if not is_inside_tree():
			return
	# Garantir que sai para o menu inicial mesmo se estiver em callbacks de física.
	get_tree().change_scene_to_file("res://ui/MainMenu.tscn")

func begin_run() -> void:
	# Chamado quando se entra no jogo a partir do menu (permite re-terminar o jogo).
	_return_to_menu_queued = false

func get_zone_root_node() -> Node2D:
	# Zona atual instanciada pelo ZoneManager (é onde devem viver pickups/cometas/etc).
	for n in get_tree().get_nodes_in_group("zone_root"):
		if n is Node2D and is_instance_valid(n) and not (n as Node).is_queued_for_deletion():
			return n as Node2D

	# Fallback: pegar no 1º filho Node2D do ZoneManager.
	var zm := get_tree().get_first_node_in_group("zone_manager")
	if zm != null:
		for c in (zm as Node).get_children():
			if c is Node2D and is_instance_valid(c) and not (c as Node).is_queued_for_deletion():
				return c as Node2D
	return null

func _process(delta: float) -> void:
	_tick_regen(delta)

func _tick_regen(delta: float) -> void:
	if not has_artifact("auto_regen"):
		return
	if player_health >= player_max_health:
		return
	_regen_cooldown = maxf(0.0, _regen_cooldown - delta)
	if _regen_cooldown > 0.0:
		_regen_accum = 0.0
		return
	var rate: float = ArtifactDatabase.get_regen_rate()
	if rate <= 0.0:
		return
	_regen_accum += rate * delta
	var heal_amount: int = int(floor(_regen_accum))
	if heal_amount <= 0:
		return
	_regen_accum -= float(heal_amount)
	heal_player(heal_amount)

func add_resource(type: String, amount: int) -> void:
	if not resources.has(type):
		resources[type] = 0
	resources[type] += amount
	print(type, " =", resources[type])

	# Rastrear tempo de ganho de recursos
	if amount > 0:
		last_resource_gain_time = Time.get_ticks_msec() / 1000.0

	_record_resource_gain(type, amount)
	emit_signal("state_changed")
	_queue_save()

func _record_resource_gain(type: String, amount: int) -> void:
	if amount <= 0:
		return

	var changed := false
	for quest_id_variant in quests.keys():
		var quest_id := str(quest_id_variant)
		var q: Dictionary = quests.get(quest_id, {}) as Dictionary
		if not bool(q.get("accepted", false)):
			continue
		if bool(q.get("completed", false)):
			continue

		var def: Dictionary = QUEST_DEFS.get(quest_id, {}) as Dictionary
		var res_type := str(def.get("resource_type", ""))
		if res_type.is_empty() or res_type != type:
			continue

		var goal: int = int(def.get("goal", 0))
		var progress: int = int(q.get("progress", 0))
		progress = min(progress + amount, goal)
		q["progress"] = progress
		if progress >= goal:
			q["completed"] = true
		quests[quest_id] = q
		changed = true

	if changed:
		emit_signal("state_changed")
		_queue_save()

func give_zone2_mining_drill_near_player(avoid_world_pos: Vector2 = Vector2.ZERO) -> bool:
	# Dá a broca (1 peça) ao jogador via pickup ao pé do player.
	if has_artifact("mining_drill"):
		return false

	zone2_drill_given = true

	var zm: Node = get_tree().get_first_node_in_group("zone_manager") as Node
	var zone_node: Node2D = null
	if zm != null:
		for c in zm.get_children():
			if c is Node2D:
				zone_node = c as Node2D
				break
	if zone_node == null:
		emit_signal("state_changed")
		_queue_save()
		return false

	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		emit_signal("state_changed")
		_queue_save()
		return false

	var spawn_global := player.global_position + Vector2(-520, 0)
	if avoid_world_pos != Vector2.ZERO:
		var d := spawn_global.distance_to(avoid_world_pos)
		if d < 260.0:
			var away := (player.global_position - avoid_world_pos).normalized()
			if away == Vector2.ZERO:
				away = Vector2.RIGHT
			spawn_global = player.global_position + away * 520.0
	mining_drill_part_local = zone_node.to_local(spawn_global)

	var part_scene: PackedScene = load("res://pickups/ArtifactPart.tscn")
	if part_scene == null:
		emit_signal("state_changed")
		_queue_save()
		return false

	var inst: Node = part_scene.instantiate()
	if inst == null or not (inst is Node2D):
		emit_signal("state_changed")
		_queue_save()
		return false

	var part := inst as Node2D
	part.position = mining_drill_part_local
	part.set("artifact_id", "mining_drill")
	zone_node.add_child(part)

	emit_signal("state_changed")
	_queue_save()
	return true

func record_vacuum_use() -> void:
	# Conta apenas os usos iniciais (tutorial). Depois de reparado, o Vacuum nao volta a partir.
	if vacuum_broken_once:
		return
	if vacuum_is_broken:
		return
	if not has_artifact("vacuum"):
		return
	if vacuum_intro_uses_left <= 0:
		return

	vacuum_intro_uses_left -= 1
	if vacuum_intro_uses_left <= 0:
		_break_vacuum()
	else:
		emit_signal("state_changed")
		_queue_save()

func _break_vacuum() -> void:
	if vacuum_broken_once:
		return
	vacuum_broken_once = true
	vacuum_is_broken = true
	vacuum_intro_uses_left = 0

	# Remove o gadget e volta ao fluxo normal de "arranjar pecas".
	var idx := unlocked_artifacts.find("vacuum")
	if idx >= 0:
		unlocked_artifacts.remove_at(idx)
	artifact_parts["vacuum"] = 0

	# Reset ao loop de obtencao das pecas (mapa + peca aleatoria + compra).
	vacuum_map_bought = false
	vacuum_random_part_local = Vector2.ZERO
	vacuum_random_part_world = Vector2.ZERO
	vacuum_random_part_collected = false
	vacuum_shop_part_bought = false

	# Mensagens movidas para HintSystem._schedule_vacuum_break_hint()
	emit_signal("vacuum_broken")
	emit_signal("state_changed")
	_queue_save()

func has_all_gadgets() -> bool:
	for artifact_id_variant in ArtifactDatabase.ARTIFACTS.keys():
		var artifact_id := str(artifact_id_variant)
		if not has_artifact(artifact_id):
			return false
	return true

func get_missing_gadgets() -> Array[String]:
	var missing: Array[String] = []
	for artifact_id_variant in ArtifactDatabase.ARTIFACTS.keys():
		var artifact_id := str(artifact_id_variant)
		if not has_artifact(artifact_id):
			missing.append(artifact_id)
	return missing

func try_request_zone2_core_horde() -> Dictionary:
	# Devolve {ok: bool, message: String}
	var req := get_zone2_core_horde_requirements()
	if not bool(req.get("ok", false)):
		return req

	mid_core_event_triggered = true
	_queue_save()
	emit_signal("zone2_core_horde_requested")
	return {"ok": true, "message": "Ok. A chamar reforcos..."}

func get_zone2_core_horde_requirements() -> Dictionary:
	# Devolve {ok: bool, message: String} sem efeitos secundários.
	if current_zone_id != "mid":
		return {"ok": false, "message": "Isto so pode ser feito na Zona 2."}
	if mid_core_patrol_cleared:
		return {"ok": false, "message": "Os Humanos ja foram derrotados."}
	if mid_core_event_triggered:
		return {"ok": false, "message": "A patrulha ja foi chamada."}

	var missing := get_missing_gadgets()
	var avg := get_average_ship_upgrade_level()
	if not missing.is_empty() or avg < 8.0:
		var msg := "Ainda tens de ficar mais forte."
		if not missing.is_empty():
			var titles: Array[String] = []
			for gid in missing:
				titles.append(ArtifactDatabase.get_artifact_title(gid))
			msg += "\nObtem os gadgets que te faltam: %s." % ", ".join(titles)
		if avg < 8.0:
			msg += "\nUpgrades a nvl 8 (media atual: %.1f)." % avg
		return {"ok": false, "message": msg}

	return {"ok": true, "message": "Ok. A chamar reforcos..."}

func has_upgrades_at_least(min_level: int) -> bool:
	for upgrade_id_variant in upgrades.keys():
		var upgrade_id := str(upgrade_id_variant)
		if upgrade_id.begins_with("aux_"):
			continue
		if get_upgrade_level(upgrade_id) < min_level:
			return false
	return true

func get_average_ship_upgrade_level() -> float:
	var total: int = 0
	var count: int = 0
	for upgrade_id_variant in upgrades.keys():
		var upgrade_id := str(upgrade_id_variant)
		if upgrade_id.begins_with("aux_"):
			continue
		total += get_upgrade_level(upgrade_id)
		count += 1
	if count <= 0:
		return 0.0
	return float(total) / float(count)

func is_vault_unlocked(station_id: String) -> bool:
	return bool(vault_unlocked.get(station_id, false))

func buy_vault(station_id: String, cost: Dictionary) -> bool:
	if station_id.is_empty():
		return false
	if is_vault_unlocked(station_id):
		return false
	if not can_afford(cost):
		return false

	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type])

	vault_unlocked[station_id] = true
	if not vault_resources.has(station_id):
		vault_resources[station_id] = {}
	emit_signal("state_changed")
	_queue_save()
	return true

func get_vault_balance(station_id: String, res_type: String) -> int:
	var station_vault := vault_resources.get(station_id, {}) as Dictionary
	return int(station_vault.get(res_type, 0))

func deposit_to_vault(station_id: String, res_type: String, amount: int) -> bool:
	if amount <= 0:
		return false
	if not is_vault_unlocked(station_id):
		return false
	var have := int(resources.get(res_type, 0))
	if have <= 0:
		return false
	amount = min(amount, have)

	resources[res_type] = have - amount
	var station_vault := vault_resources.get(station_id, {}) as Dictionary
	station_vault[res_type] = int(station_vault.get(res_type, 0)) + amount
	vault_resources[station_id] = station_vault
	emit_signal("state_changed")
	_queue_save()
	return true

func withdraw_from_vault(station_id: String, res_type: String, amount: int) -> bool:
	if amount <= 0:
		return false
	if not is_vault_unlocked(station_id):
		return false
	var station_vault := vault_resources.get(station_id, {}) as Dictionary
	var have := int(station_vault.get(res_type, 0))
	if have <= 0:
		return false
	amount = min(amount, have)

	station_vault[res_type] = have - amount
	vault_resources[station_id] = station_vault
	resources[res_type] = int(resources.get(res_type, 0)) + amount
	emit_signal("state_changed")
	_queue_save()
	return true

func _lose_carried_resources_on_death() -> void:
	# Perde apenas recursos "no inventario" (o que esta no cofre fica).
	resources["scrap"] = 0
	resources["mineral"] = 0
	resources["ametista"] = 0
	emit_signal("state_changed")
	_queue_save()

func accept_quest(quest_id: String, station_id: String = "") -> bool:
	if not QUEST_DEFS.has(quest_id):
		return false
	if is_bandit_quest(quest_id) and quest_id != get_current_bandit_quest_id():
		return false

	var q: Dictionary = quests.get(quest_id, {}) as Dictionary
	if q.is_empty():
		q = _make_default_quest_state()

	if bool(q.get("archived", false)) or bool(q.get("claimed", false)):
		return false

	if bool(q.get("accepted", false)):
		return false

	q["accepted"] = true
	if not station_id.is_empty():
		q["accepted_station_id"] = station_id
	quests[quest_id] = q

	# Revelar estação target se a quest tiver uma
	var def: Dictionary = QUEST_DEFS.get(quest_id, {}) as Dictionary
	var target_station := str(def.get("target_station_id", ""))
	if not target_station.is_empty() and not is_station_discovered(target_station):
		discover_station(target_station)
		emit_signal("speech_requested", "A localização foi marcada no teu mapa!")

	emit_signal("state_changed")
	_queue_save()
	return true

func record_enemy_kill(enemy_id: String) -> void:
	# Rastrear tempo de kill de inimigos
	last_enemy_kill_time = Time.get_ticks_msec() / 1000.0

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
		
		# Suporte para "any" - qualquer inimigo conta
		if required_enemy_id == "any":
			# Qualquer kill conta
			pass
		# Suporte para "mixed" - precisa de lógica especial
		elif required_enemy_id == "mixed":
			# Para mixed, precisamos contar separadamente cada tipo
			# Por enquanto, vamos contar qualquer kill como progresso
			# (pode ser melhorado depois com tracking específico)
			pass
		elif required_enemy_id.is_empty() or required_enemy_id != enemy_id:
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
	if is_bandit_quest(quest_id) and quest_id != get_current_bandit_quest_id():
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

func can_claim_quest_at_station(quest_id: String, station_id: String) -> bool:
	if not can_claim_quest(quest_id):
		return false
	var q: Dictionary = quests.get(quest_id, {}) as Dictionary
	var accepted_station_id := str(q.get("accepted_station_id", ""))
	if accepted_station_id.is_empty():
		return true
	return accepted_station_id == station_id

func claim_quest(quest_id: String, station_id: String = "") -> bool:
	if station_id.is_empty():
		if not can_claim_quest(quest_id):
			return false
	else:
		if not can_claim_quest_at_station(quest_id, station_id):
			return false

	var q_check: Dictionary = quests.get(quest_id, {}) as Dictionary
	var accepted_station_id := str(q_check.get("accepted_station_id", ""))
	if not accepted_station_id.is_empty() and not station_id.is_empty() and accepted_station_id != station_id:
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

	var map_reward := str(def.get("map_reward", ""))
	if map_reward == "side_dash":
		side_dash_map_unlocked = true
	elif map_reward == "aux_ship":
		aux_ship_map_unlocked = true
	elif map_reward == "random_station":
		# Descobre uma estação aleatória não descoberta
		var all_stations := ["station_alpha", "station_beta", "station_gamma", "station_delta", "station_zeta"]
		var undiscovered: Array[String] = []
		for sid in all_stations:
			if not is_station_discovered(sid):
				undiscovered.append(sid)
		if not undiscovered.is_empty():
			var random_station := undiscovered[randi() % undiscovered.size()]
			discover_station(random_station)

	var discover_station_reward := str(def.get("discover_station_reward", ""))
	if not discover_station_reward.is_empty():
		discover_station(discover_station_reward)
	
	var consumable_reward: Dictionary = def.get("consumable_reward", {}) as Dictionary
	for consumable_type_variant in consumable_reward.keys():
		var consumable_type := str(consumable_type_variant)
		var count := int(consumable_reward[consumable_type_variant])
		_add_consumable(consumable_type, count)

	var q: Dictionary = quests.get(quest_id, {}) as Dictionary
	q["claimed"] = true
	quests[quest_id] = q

	# Rastrear tempo de claim de quest
	last_quest_claim_time = Time.get_ticks_msec() / 1000.0

	# Mensagem aleatória de conclusão de missão
	var completion_messages: Array[String] = [
		"Pega!!",
		"Bumba na fofinha;)",
		"+1 pimba!",
		"Bota pra dentro"
	]
	var random_message := completion_messages[randi() % completion_messages.size()]
	emit_signal("speech_requested", random_message)

	emit_signal("state_changed")
	_queue_save()
	return true

func get_tavern_hi_score(station_id: String) -> int:
	var base: int = int(StationCatalog.get_tavern_base_score(station_id))
	if base < 0:
		base = 0
	var current: int = int(tavern_hi_scores.get(station_id, base))
	if current < base:
		current = base
	return current

func record_tavern_score(station_id: String, score: int) -> Dictionary:
	var result := {"new_hi": false, "rewarded": false, "reward": {}}
	if station_id.is_empty():
		return result

	var current := get_tavern_hi_score(station_id)
	if score <= current:
		return result

	tavern_hi_scores[station_id] = score
	result["new_hi"] = true

	if not bool(tavern_reward_claimed.get(station_id, false)):
		var reward: Dictionary = StationCatalog.get_tavern_reward(station_id)
		if not reward.is_empty():
			for res_type_variant in reward.keys():
				var res_type := str(res_type_variant)
				resources[res_type] = int(resources.get(res_type, 0)) + int(reward[res_type])
			tavern_reward_claimed[station_id] = true
			result["rewarded"] = true
			result["reward"] = reward

	emit_signal("state_changed")
	_queue_save()
	return result

func clear_completed_quest(quest_id: String) -> bool:
	var q: Dictionary = quests.get(quest_id, {}) as Dictionary
	if q.is_empty():
		return false
	# Permite limpar missões concluídas mesmo que o jogador não tenha reclamado a recompensa.
	# (Se não foi reclamada, a limpeza significa desistir dela.)
	if not bool(q.get("completed", false)):
		return false

	q["accepted"] = false
	q["archived"] = true
	quests[quest_id] = q
	emit_signal("state_changed")
	_queue_save()
	return true

func get_quest_state(quest_id: String) -> Dictionary:
	return quests.get(quest_id, {}) as Dictionary

func is_bandit_quest(quest_id: String) -> bool:
	return BANDIT_QUESTS.has(quest_id)

func get_current_bandit_quest_id() -> String:
	for quest_id in BANDIT_QUESTS:
		var q: Dictionary = get_quest_state(quest_id)
		if not bool(q.get("claimed", false)):
			return quest_id
	return ""

func get_bandit_quest_index(quest_id: String) -> int:
	var idx := BANDIT_QUESTS.find(quest_id)
	if idx < 0:
		return 0
	return idx + 1

func is_bandit_chain_complete() -> bool:
	for quest_id in BANDIT_QUESTS:
		var q: Dictionary = get_quest_state(quest_id)
		if not bool(q.get("claimed", false)):
			return false
	return true

func has_boss_planet_marker() -> bool:
	if not QUEST_DEFS.has(QUEST_BOSS_PLANET):
		return false
	var q: Dictionary = get_quest_state(QUEST_BOSS_PLANET)
	return bool(q.get("accepted", false)) or bool(q.get("completed", false)) or bool(q.get("claimed", false))

func should_show_boss_compass() -> bool:
	if not QUEST_DEFS.has(QUEST_BOSS_PLANET):
		return false
	var q: Dictionary = get_quest_state(QUEST_BOSS_PLANET)
	return bool(q.get("accepted", false)) and not bool(q.get("claimed", false)) and not boss_planet_resources_unlocked

func is_boss_defeated() -> bool:
	if not QUEST_DEFS.has(QUEST_BOSS_PLANET):
		return false
	var q: Dictionary = get_quest_state(QUEST_BOSS_PLANET)
	return bool(q.get("completed", false)) or bool(q.get("claimed", false))

func has_boss_planet_resources_unlocked() -> bool:
	return boss_planet_resources_unlocked

func can_unlock_boss_planet_resources() -> bool:
	return is_boss_defeated() and not boss_planet_resources_unlocked

func unlock_boss_planet_resources() -> bool:
	if not can_unlock_boss_planet_resources():
		return false
	boss_planet_resources_unlocked = true
	emit_signal("state_changed")
	_queue_save()
	return true

func filter_offered_quests(quest_ids: Array) -> Array:
	var filtered: Array[String] = []
	var current_bandit := get_current_bandit_quest_id()
	for quest_id_variant in quest_ids:
		var quest_id := str(quest_id_variant)
		if is_bandit_quest(quest_id):
			if quest_id == current_bandit:
				filtered.append(quest_id)
		elif quest_id == QUEST_BOSS_PLANET:
			var q: Dictionary = get_quest_state(quest_id)
			if is_bandit_chain_complete() and not bool(q.get("claimed", false)):
				filtered.append(quest_id)
		else:
			filtered.append(quest_id)
	return filtered

func _make_default_quest_state() -> Dictionary:
	return {
		"accepted": false,
		"accepted_station_id": "",
		"progress": 0,
		"completed": false,
		"claimed": false,
		"archived": false,
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
	_regen_cooldown = ArtifactDatabase.get_regen_delay()
	_regen_accum = 0.0
	emit_signal("state_changed")
	_queue_save()
	if player_health <= 0:
		_lose_carried_resources_on_death()
		player_health = player_max_health
		emit_signal("player_died")

func heal_player(amount: int) -> void:
	player_health = min(player_health + amount, player_max_health)
	emit_signal("state_changed")
	_queue_save()

func buy_repair_kit(cost: Dictionary) -> bool:
	if get_repair_kit_count() >= MAX_REPAIR_KITS:
		return false
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type])
	_add_consumable("repair_kit", 1)
	emit_signal("state_changed")
	_queue_save()
	return true

func _add_consumable(consumable_type: String, count: int) -> void:
	if count <= 0:
		return
	var current: int = int(consumables.get(consumable_type, 0))
	var new_value: int = current + count
	if consumable_type == "repair_kit":
		new_value = mini(new_value, MAX_REPAIR_KITS)
	consumables[consumable_type] = new_value

func buy_vacuum_map(cost: Dictionary) -> bool:
	if vacuum_map_bought:
		return false
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type])
	vacuum_map_bought = true
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_artifact_part_by_id(artifact_id: String, cost: Dictionary) -> bool:
	if not ArtifactDatabase.is_valid_artifact(artifact_id):
		return false
	if has_artifact(artifact_id):
		return false
	var required := ArtifactDatabase.get_parts_required(artifact_id)
	if required <= 0:
		return false
	if get_artifact_parts(artifact_id) >= required:
		return false
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type])
	collect_artifact_part(artifact_id)
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_vacuum_shop_part(station_id: String, cost: Dictionary) -> bool:
	if station_id != "station_epsilon":
		return false
	if vacuum_shop_part_bought:
		return false
	if has_artifact("vacuum"):
		return false
	var required := ArtifactDatabase.get_parts_required("vacuum")
	if required <= 0:
		return false
	if get_artifact_parts("vacuum") >= required:
		return false
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	collect_artifact_part("vacuum")
	vacuum_shop_part_bought = true
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_reverse_thruster_shop_part(station_id: String, cost: Dictionary) -> bool:
	if station_id != "station_alpha" and station_id != "station_delta":
		return false
	if has_artifact("reverse_thruster"):
		return false
	var required := ArtifactDatabase.get_parts_required("reverse_thruster")
	if required <= 0:
		return false
	if get_artifact_parts("reverse_thruster") >= required:
		return false
	if bool(reverse_thruster_shop_parts_bought.get(station_id, false)):
		return false
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	collect_artifact_part("reverse_thruster")
	reverse_thruster_shop_parts_bought[station_id] = true
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_reverse_thruster_map(station_id: String, cost: Dictionary) -> bool:
	if station_id != "station_alpha":
		return false
	if reverse_thruster_map_bought:
		return false
	if has_artifact("reverse_thruster") or reverse_thruster_random_part_collected:
		return false
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	reverse_thruster_map_bought = true
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_side_dash_shop_part(station_id: String, cost: Dictionary) -> bool:
	# Apenas na Zona 2.
	if current_zone_id != "mid":
		return false
	if station_id != "station_zeta" and station_id != "station_beta":
		return false
	if has_artifact("side_dash"):
		return false
	var required := ArtifactDatabase.get_parts_required("side_dash")
	if required <= 0:
		return false
	if get_artifact_parts("side_dash") >= required:
		return false
	if bool(side_dash_shop_parts_bought.get(station_id, false)):
		return false
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	collect_artifact_part("side_dash")
	side_dash_shop_parts_bought[station_id] = true
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_auto_regen_map_zone1(station_id: String, cost: Dictionary) -> bool:
	if station_id != "station_alpha":
		return false
	if auto_regen_map_zone1_bought:
		return false
	if has_artifact("auto_regen") or auto_regen_part1_collected:
		return false
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	auto_regen_map_zone1_bought = true
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_auto_regen_map_zone2(station_id: String, cost: Dictionary) -> bool:
	if current_zone_id != "mid":
		return false
	if station_id != "station_zeta":
		return false
	if auto_regen_map_zone2_bought:
		return false
	if has_artifact("auto_regen") or auto_regen_part2_collected:
		return false
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	auto_regen_map_zone2_bought = true
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_aux_ship_shop_part(station_id: String, cost: Dictionary) -> bool:
	if current_zone_id != "mid":
		return false
	if station_id != "station_beta":
		return false
	if aux_ship_shop_part_bought:
		return false
	if has_artifact("aux_ship"):
		return false
	var required := ArtifactDatabase.get_parts_required("aux_ship")
	if required <= 0:
		return false
	if get_artifact_parts("aux_ship") >= required:
		return false
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	collect_artifact_part("aux_ship")
	aux_ship_shop_part_bought = true
	emit_signal("state_changed")
	_queue_save()
	return true

func get_repair_kit_count() -> int:
	return int(consumables.get("repair_kit", 0))

func use_repair_kit() -> bool:
	var count := get_repair_kit_count()
	if count <= 0:
		return false
	var half := int(floor(float(player_max_health) * 0.5))
	if half <= 0:
		half = 1
	consumables["repair_kit"] = count - 1
	heal_player(half)
	emit_signal("state_changed")
	_queue_save()
	return true

func repair_ship(cost: Dictionary) -> bool:
	if not can_afford(cost):
		return false
	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type])
	player_health = player_max_health
	emit_signal("state_changed")
	_queue_save()
	return true

func debug_grant_test_resources() -> void:
	var add: Dictionary = {
		"scrap": 5000,
		"mineral": 2500,
		"ametista": 250,
	}
	for res_type_variant in add.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) + int(add[res_type_variant])
	_add_consumable("repair_kit", 20)
	emit_signal("state_changed")
	_queue_save()

func reset_alien_health() -> void:
	alien_health = alien_max_health
	emit_signal("state_changed")

func damage_alien(amount: int) -> void:
	alien_health = max(alien_health - amount, 0)
	emit_signal("state_changed")
	if alien_health <= 0:
		_lose_carried_resources_on_death()
		alien_health = alien_max_health
		emit_signal("alien_died")

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

func has_aux_ship() -> bool:
	return has_artifact("aux_ship")

func has_mining_drill() -> bool:
	return has_artifact("mining_drill")

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

func get_player_laser_damage() -> int:
	var level := get_upgrade_level("laser_damage")
	var value := float(BASE_PLAYER_LASER_DAMAGE) * pow(1.10, level)
	return int(round(value))

func get_player_laser_speed() -> float:
	var level := get_upgrade_level("laser_speed")
	return BASE_PLAYER_LASER_SPEED * pow(1.10, level)

func get_aux_ship_fire_interval() -> float:
	var base := ArtifactDatabase.get_aux_ship_fire_interval()
	var level := get_upgrade_level("aux_fire_rate")
	return max(0.08, base * pow(0.92, level))

func get_aux_ship_laser_damage() -> int:
	var base := ArtifactDatabase.get_aux_ship_laser_damage()
	var level := get_upgrade_level("aux_damage")
	var value := float(base) * pow(1.12, level)
	return int(round(value))

func get_aux_ship_laser_speed() -> float:
	var level := get_upgrade_level("aux_laser_speed")
	return BASE_AUX_LASER_SPEED * pow(1.10, level)

func get_aux_ship_range() -> float:
	var base := ArtifactDatabase.get_aux_ship_range()
	var level := get_upgrade_level("aux_range")
	return base * (1.0 + 0.08 * level)

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
		"laser_damage":
			return "Aumenta o dano do laser (+10% por nivel)."
		"laser_speed":
			return "Dispara lasers mais rapidos (+10% velocidade por nivel)."
		"engine":
			return "Mais aceleração (+12% por nível)."
		"thrusters":
			return "Mais velocidade máxima (+10% por nível)."
		"magnet":
			return "Aumenta o magnet dos drops (+20% range e +15% speed por nível)."

		"aux_fire_rate":
			return "Nave auxiliar dispara mais rapido (+8% cadencia por nivel)."
		"aux_damage":
			return "Aumenta o dano do laser da nave auxiliar (+12% por nivel)."
		"aux_range":
			return "Aumenta o alcance da nave auxiliar (+8% por nivel)."
		"aux_laser_speed":
			return "Aumenta a velocidade dos lasers da nave auxiliar (+10% por nivel)."

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
	var next_level := level + 1

	var cost := {}
	for res_type in base_cost.keys():
		var base_amount := int(base_cost[res_type])
		var scaled := int(ceil(base_amount * pow(growth, level)))
		cost[res_type] = max(scaled, 0)

	var extra_ametista := 0
	if next_level == 8:
		extra_ametista = 1
	elif next_level == 9:
		extra_ametista = 2
	elif next_level == 10:
		extra_ametista = 3
	if extra_ametista > 0:
		cost["ametista"] = int(cost.get("ametista", 0)) + extra_ametista
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

	# Rastrear tempo de upgrade
	last_upgrade_time = Time.get_ticks_msec() / 1000.0

	_recalculate_player_stats()
	emit_signal("state_changed")
	_queue_save()
	return true

func collect_artifact_part(artifact_id: String = "relic") -> void:
	if artifact_id == "relic":
		if artifact_completed:
			return
		var prev_relics: int = artifact_parts_collected

		artifact_parts_collected = min(artifact_parts_collected + 1, ARTIFACT_PARTS_REQUIRED)
		if artifact_parts_collected >= ARTIFACT_PARTS_REQUIRED:
			artifact_completed = true
			resources["artifact"] = int(resources.get("artifact", 0)) + 1
			# Recompensa simples (ajusta quando tiveres balanceamento)
			resources["scrap"] = int(resources.get("scrap", 0)) + 25
			resources["mineral"] = int(resources.get("mineral", 0)) + 25

		_recalculate_zone_unlocks()
		var required_core: int = ZoneCatalog.get_required_artifact_parts("core")
		if prev_relics < required_core and artifact_parts_collected >= required_core:
			emit_signal("speech_requested", "Agora ja tenho o que preciso para viajar para o nucleo")
			emit_signal("speech_requested", "Pressione M")
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

	# Mensagem ao apanhar parte de artefacto
	var artifact_title: String = ArtifactDatabase.get_artifact_title(artifact_id)
	if current < required:
		emit_signal("speech_requested", "Apanhei uma parte de %s! (%d/%d)" % [artifact_title, current, required])
		get_tree().create_timer(5.0).timeout.connect(func():
			emit_signal("speech_requested", "Usa Tab para ver o inventário.")
		)

	if current >= required:
		unlocked_artifacts.append(artifact_id)
		if artifact_id == "vacuum":
			vacuum_is_broken = false

		# Rastrear tempo de unlock de artefacto
		last_artifact_unlock_time = Time.get_ticks_msec() / 1000.0

		# Mostrar balão de fala quando desbloqueia um artefato
		var artifact_description: String = ArtifactDatabase.get_artifact_description(artifact_id)
		emit_signal("speech_requested", "Uau arranjei %s!" % artifact_title)

		# Mostrar descrição 5 segundos depois
		if not artifact_description.is_empty():
			get_tree().create_timer(5.0).timeout.connect(func():
				emit_signal("speech_requested", artifact_description)
			)

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

	# Verificar se é a primeira vez a visitar esta zona
	var is_first_visit := not visited_zones.has(zone_id)
	if is_first_visit:
		visited_zones.append(zone_id)
		# Mensagens de chegada por zona (evitar duplicados no boss da zona 3).
		if zone_id == "mid":
			emit_signal("speech_requested", "Uau esta zona tem uma cor estranha.")

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

	# Resetar o HintSystem também
	if has_node("/root/HintSystem"):
		var hint_system = get_node("/root/HintSystem")
		if hint_system.has_method("reset_all"):
			hint_system.reset_all()

	emit_signal("state_changed")

func is_station_discovered(station_id: String) -> bool:
	if station_id.is_empty():
		return false
	return discovered_station_ids.has(station_id)

func discover_station(station_id: String) -> void:
	if station_id.is_empty():
		return
	if discovered_station_ids.has(station_id):
		return
	discovered_station_ids.append(station_id)
	
	# Atualizar missão de descobrir estações
	_record_station_discovery()
	
	emit_signal("state_changed")
	_queue_save()

func _record_station_discovery() -> void:
	var quest_id := QuestDatabase.QUEST_DISCOVER_2_STATIONS
	var q: Dictionary = quests.get(quest_id, {}) as Dictionary
	if not bool(q.get("accepted", false)):
		return
	if bool(q.get("completed", false)):
		return
	
	var def: Dictionary = QuestDatabase.QUEST_DEFS.get(quest_id, {}) as Dictionary
	var goal: int = int(def.get("goal", 0))
	var progress: int = int(q.get("progress", 0))
	
	# Incrementa o progresso quando uma estação é descoberta
	progress = min(progress + 1, goal)
	q["progress"] = progress
	
	if progress >= goal:
		q["completed"] = true
	quests[quest_id] = q
	emit_signal("state_changed")
	_queue_save()

func buy_alpha_station_map(cost: Dictionary) -> bool:
	if alpha_station_map_bought:
		return false
	if cost.is_empty():
		return false
	if not can_afford(cost):
		return false

	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	alpha_station_map_bought = true
	discover_station("station_alpha")
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_kappa_station_map(cost: Dictionary) -> bool:
	if kappa_station_map_bought:
		return false
	if cost.is_empty():
		return false
	if not can_afford(cost):
		return false

	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	kappa_station_map_bought = true
	discover_station("station_kappa")
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_beta_station_map(cost: Dictionary) -> bool:
	if beta_station_map_bought:
		return false
	if cost.is_empty():
		return false
	if not can_afford(cost):
		return false

	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	beta_station_map_bought = true
	discover_station("station_beta")
	emit_signal("state_changed")
	_queue_save()
	return true

func buy_zeta_station_map(cost: Dictionary) -> bool:
	if zeta_station_map_bought:
		return false
	if cost.is_empty():
		return false
	if not can_afford(cost):
		return false

	for res_type_variant in cost.keys():
		var res_type := str(res_type_variant)
		resources[res_type] = int(resources.get(res_type, 0)) - int(cost[res_type_variant])
	zeta_station_map_bought = true
	discover_station("station_zeta")
	emit_signal("state_changed")
	_queue_save()
	return true

func save_game() -> void:
	var discovered: Array[String] = []
	for sid in discovered_station_ids:
		discovered.append(str(sid))

	var data := {
		"version": SAVE_VERSION,
		"resources": resources,
		"consumables": consumables,
		"discovered_stations": discovered,
		"alpha_station_map_bought": alpha_station_map_bought,
		"kappa_station_map_bought": kappa_station_map_bought,
		"beta_station_map_bought": beta_station_map_bought,
		"zeta_station_map_bought": zeta_station_map_bought,
		"defeated_bosses": defeated_bosses,
		"zone2_intro_station_local": [zone2_intro_station_local.x, zone2_intro_station_local.y],
		"zone2_drill_given": zone2_drill_given,
		"mining_drill_part_local": [mining_drill_part_local.x, mining_drill_part_local.y],
		"vacuum_map_bought": vacuum_map_bought,
		"vacuum_random_part_local": [vacuum_random_part_local.x, vacuum_random_part_local.y],
		"vacuum_random_part_collected": vacuum_random_part_collected,
		"vacuum_shop_part_bought": vacuum_shop_part_bought,
		"vacuum_intro_uses_left": vacuum_intro_uses_left,
		"vacuum_broken_once": vacuum_broken_once,
		"vacuum_is_broken": vacuum_is_broken,
		"mid_core_event_triggered": mid_core_event_triggered,
		"mid_core_patrol_cleared": mid_core_patrol_cleared,
		"reverse_thruster_map_bought": reverse_thruster_map_bought,
		"reverse_thruster_random_part_local": [reverse_thruster_random_part_local.x, reverse_thruster_random_part_local.y],
		"reverse_thruster_random_part_collected": reverse_thruster_random_part_collected,
		"reverse_thruster_shop_parts_bought": reverse_thruster_shop_parts_bought,
		"side_dash_map_unlocked": side_dash_map_unlocked,
		"side_dash_random_part_local": [side_dash_random_part_local.x, side_dash_random_part_local.y],
		"side_dash_random_part_collected": side_dash_random_part_collected,
		"side_dash_shop_parts_bought": side_dash_shop_parts_bought,
		"auto_regen_map_zone1_bought": auto_regen_map_zone1_bought,
		"auto_regen_map_zone2_bought": auto_regen_map_zone2_bought,
		"auto_regen_part1_local": [auto_regen_part1_local.x, auto_regen_part1_local.y],
		"auto_regen_part1_collected": auto_regen_part1_collected,
		"auto_regen_part2_local": [auto_regen_part2_local.x, auto_regen_part2_local.y],
		"auto_regen_part2_collected": auto_regen_part2_collected,
		"aux_ship_map_unlocked": aux_ship_map_unlocked,
		"aux_ship_random_part_local": [aux_ship_random_part_local.x, aux_ship_random_part_local.y],
		"aux_ship_random_part_collected": aux_ship_random_part_collected,
		"aux_ship_shop_part_bought": aux_ship_shop_part_bought,
		"vault_unlocked": vault_unlocked,
		"vault_resources": vault_resources,
		"quests": quests,
		"tavern_hi_scores": tavern_hi_scores,
		"tavern_reward_claimed": tavern_reward_claimed,
		"boss_planet_resources_unlocked": boss_planet_resources_unlocked,
		"upgrades": upgrades,
		"player_health": player_health,
		"artifact_parts_collected": artifact_parts_collected,
		"artifact_completed": artifact_completed,
		"artifact_parts": artifact_parts,
		"unlocked_artifacts": unlocked_artifacts,
		"current_zone_id": current_zone_id,
		"unlocked_zones": unlocked_zones,
		"visited_zones": visited_zones,
		"last_quest_claim_time": last_quest_claim_time,
		"last_upgrade_time": last_upgrade_time,
		"last_artifact_unlock_time": last_artifact_unlock_time,
		"last_resource_gain_time": last_resource_gain_time,
		"last_enemy_kill_time": last_enemy_kill_time,
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
	# garantir que ametista existe em saves antigos
	if not resources.has("ametista"):
		resources["ametista"] = 0

	alpha_station_map_bought = bool(data.get("alpha_station_map_bought", false))
	kappa_station_map_bought = bool(data.get("kappa_station_map_bought", false))
	beta_station_map_bought = bool(data.get("beta_station_map_bought", false))
	zeta_station_map_bought = bool(data.get("zeta_station_map_bought", false))
	
	# Carregar bosses mortos
	defeated_bosses = []
	var loaded_defeated_bosses: Variant = data.get("defeated_bosses")
	if typeof(loaded_defeated_bosses) == TYPE_ARRAY:
		for boss_id_variant in (loaded_defeated_bosses as Array):
			var boss_id := str(boss_id_variant)
			if not boss_id.is_empty() and not defeated_bosses.has(boss_id):
				defeated_bosses.append(boss_id)
	elif typeof(loaded_defeated_bosses) == TYPE_PACKED_STRING_ARRAY:
		defeated_bosses = loaded_defeated_bosses
	
	discovered_station_ids = PackedStringArray([])
	var stored_discovered: Variant = data.get("discovered_stations")
	if typeof(stored_discovered) == TYPE_ARRAY:
		for sid_variant in (stored_discovered as Array):
			var sid := str(sid_variant)
			if sid.is_empty():
				continue
			if not discovered_station_ids.has(sid):
				discovered_station_ids.append(sid)

	# Garantia: Refugio Epsilon aparece sempre no inicio.
	if not discovered_station_ids.has("station_epsilon"):
		discovered_station_ids.append("station_epsilon")

	var stored_zone2_station: Variant = data.get("zone2_intro_station_local")
	if typeof(stored_zone2_station) == TYPE_ARRAY and (stored_zone2_station as Array).size() >= 2:
		var a2 := stored_zone2_station as Array
		zone2_intro_station_local = Vector2(float(a2[0]), float(a2[1]))
	else:
		zone2_intro_station_local = Vector2.ZERO
	zone2_drill_given = bool(data.get("zone2_drill_given", false))
	var stored_drill: Variant = data.get("mining_drill_part_local")
	if typeof(stored_drill) == TYPE_ARRAY and (stored_drill as Array).size() >= 2:
		var ad := stored_drill as Array
		mining_drill_part_local = Vector2(float(ad[0]), float(ad[1]))
	else:
		mining_drill_part_local = Vector2.ZERO

	vacuum_map_bought = bool(data.get("vacuum_map_bought", false))
	vacuum_random_part_collected = bool(data.get("vacuum_random_part_collected", false))
	vacuum_shop_part_bought = bool(data.get("vacuum_shop_part_bought", false))
	vacuum_intro_uses_left = int(data.get("vacuum_intro_uses_left", 30))
	vacuum_broken_once = bool(data.get("vacuum_broken_once", false))
	vacuum_is_broken = bool(data.get("vacuum_is_broken", false))
	mid_core_event_triggered = bool(data.get("mid_core_event_triggered", false))
	mid_core_patrol_cleared = bool(data.get("mid_core_patrol_cleared", false))
	var stored_vac = data.get("vacuum_random_part_local")
	if typeof(stored_vac) == TYPE_ARRAY and (stored_vac as Array).size() >= 2:
		var a := stored_vac as Array
		vacuum_random_part_local = Vector2(float(a[0]), float(a[1]))
	else:
		vacuum_random_part_local = Vector2.ZERO
	vacuum_random_part_world = Vector2.ZERO
	reverse_thruster_map_bought = bool(data.get("reverse_thruster_map_bought", false))
	reverse_thruster_random_part_collected = bool(data.get("reverse_thruster_random_part_collected", false))
	var stored_rt = data.get("reverse_thruster_random_part_local")
	if typeof(stored_rt) == TYPE_ARRAY and (stored_rt as Array).size() >= 2:
		var a_rt := stored_rt as Array
		reverse_thruster_random_part_local = Vector2(float(a_rt[0]), float(a_rt[1]))
	else:
		reverse_thruster_random_part_local = Vector2.ZERO
	reverse_thruster_random_part_world = Vector2.ZERO
	var loaded_rt_shops = data.get("reverse_thruster_shop_parts_bought")
	if typeof(loaded_rt_shops) == TYPE_DICTIONARY:
		reverse_thruster_shop_parts_bought = loaded_rt_shops
	else:
		reverse_thruster_shop_parts_bought = {}

	side_dash_map_unlocked = bool(data.get("side_dash_map_unlocked", false))
	side_dash_random_part_collected = bool(data.get("side_dash_random_part_collected", false))
	var stored_sd = data.get("side_dash_random_part_local")
	if typeof(stored_sd) == TYPE_ARRAY and (stored_sd as Array).size() >= 2:
		var a_sd := stored_sd as Array
		side_dash_random_part_local = Vector2(float(a_sd[0]), float(a_sd[1]))
	else:
		side_dash_random_part_local = Vector2.ZERO
	side_dash_random_part_world = Vector2.ZERO
	var loaded_sd_shops = data.get("side_dash_shop_parts_bought")
	if typeof(loaded_sd_shops) == TYPE_DICTIONARY:
		side_dash_shop_parts_bought = loaded_sd_shops
	else:
		side_dash_shop_parts_bought = {}
	# Migração: Station Alpha deixou de existir na Zona 2; agora é Posto Zeta.
	if side_dash_shop_parts_bought.has("station_alpha") and not side_dash_shop_parts_bought.has("station_zeta"):
		side_dash_shop_parts_bought["station_zeta"] = bool(side_dash_shop_parts_bought.get("station_alpha", false))
		side_dash_shop_parts_bought.erase("station_alpha")

	auto_regen_map_zone1_bought = bool(data.get("auto_regen_map_zone1_bought", false))
	auto_regen_map_zone2_bought = bool(data.get("auto_regen_map_zone2_bought", false))
	auto_regen_part1_collected = bool(data.get("auto_regen_part1_collected", false))
	auto_regen_part2_collected = bool(data.get("auto_regen_part2_collected", false))
	var stored_ar1 = data.get("auto_regen_part1_local")
	if typeof(stored_ar1) == TYPE_ARRAY and (stored_ar1 as Array).size() >= 2:
		var a_ar1 := stored_ar1 as Array
		auto_regen_part1_local = Vector2(float(a_ar1[0]), float(a_ar1[1]))
	else:
		auto_regen_part1_local = Vector2.ZERO
	auto_regen_part1_world = Vector2.ZERO
	var stored_ar2 = data.get("auto_regen_part2_local")
	if typeof(stored_ar2) == TYPE_ARRAY and (stored_ar2 as Array).size() >= 2:
		var a_ar2 := stored_ar2 as Array
		auto_regen_part2_local = Vector2(float(a_ar2[0]), float(a_ar2[1]))
	else:
		auto_regen_part2_local = Vector2.ZERO
	auto_regen_part2_world = Vector2.ZERO
	aux_ship_map_unlocked = bool(data.get("aux_ship_map_unlocked", false))
	aux_ship_random_part_collected = bool(data.get("aux_ship_random_part_collected", false))
	aux_ship_shop_part_bought = bool(data.get("aux_ship_shop_part_bought", false))
	var stored_aux = data.get("aux_ship_random_part_local")
	if typeof(stored_aux) == TYPE_ARRAY and (stored_aux as Array).size() >= 2:
		var a_aux := stored_aux as Array
		aux_ship_random_part_local = Vector2(float(a_aux[0]), float(a_aux[1]))
	else:
		aux_ship_random_part_local = Vector2.ZERO
	aux_ship_random_part_world = Vector2.ZERO

	var loaded_consumables = data.get("consumables")
	if typeof(loaded_consumables) == TYPE_DICTIONARY:
		consumables.clear()
		for item_id in (loaded_consumables as Dictionary).keys():
			consumables[str(item_id)] = int(loaded_consumables[item_id])
	if not consumables.has("repair_kit"):
		consumables["repair_kit"] = 0

	var loaded_vault_unlocked = data.get("vault_unlocked")
	if typeof(loaded_vault_unlocked) == TYPE_DICTIONARY:
		vault_unlocked = loaded_vault_unlocked

	var loaded_vault_resources = data.get("vault_resources")
	if typeof(loaded_vault_resources) == TYPE_DICTIONARY:
		vault_resources = loaded_vault_resources

	var loaded_quests = data.get("quests")
	if typeof(loaded_quests) == TYPE_DICTIONARY:
		quests = loaded_quests
		if quests.has("tavern_bandit") and not quests.has(QuestDatabase.QUEST_TAVERN_BANDIT_1):
			quests[QuestDatabase.QUEST_TAVERN_BANDIT_1] = quests["tavern_bandit"]
			quests.erase("tavern_bandit")

	var loaded_tavern_scores = data.get("tavern_hi_scores")
	if typeof(loaded_tavern_scores) == TYPE_DICTIONARY:
		tavern_hi_scores = loaded_tavern_scores
	var loaded_tavern_rewards = data.get("tavern_reward_claimed")
	if typeof(loaded_tavern_rewards) == TYPE_DICTIONARY:
		tavern_reward_claimed = loaded_tavern_rewards

	boss_planet_resources_unlocked = bool(data.get("boss_planet_resources_unlocked", false))

	var loaded_upgrades = data.get("upgrades")
	if typeof(loaded_upgrades) == TYPE_DICTIONARY:
		for upgrade_id in (loaded_upgrades as Dictionary).keys():
			upgrades[upgrade_id] = int(loaded_upgrades[upgrade_id])

	player_health = int(data.get("player_health", player_max_health))
	artifact_parts_collected = min(int(data.get("artifact_parts_collected", 0)), ARTIFACT_PARTS_REQUIRED)
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

	var loaded_visited = data.get("visited_zones")
	if typeof(loaded_visited) == TYPE_ARRAY:
		visited_zones = PackedStringArray(loaded_visited)
	elif typeof(loaded_visited) == TYPE_PACKED_STRING_ARRAY:
		visited_zones = loaded_visited
	else:
		visited_zones = PackedStringArray([])

	# Carregar timestamps de hint system
	last_quest_claim_time = float(data.get("last_quest_claim_time", 0.0))
	last_upgrade_time = float(data.get("last_upgrade_time", 0.0))
	last_artifact_unlock_time = float(data.get("last_artifact_unlock_time", 0.0))
	last_resource_gain_time = float(data.get("last_resource_gain_time", 0.0))
	last_enemy_kill_time = float(data.get("last_enemy_kill_time", 0.0))
	session_start_time = Time.get_ticks_msec() / 1000.0

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
	vault_unlocked = {}
	vault_resources = {}
	quests = {}
	_ensure_quests_initialized()
	tavern_hi_scores = {}
	tavern_reward_claimed = {}
	upgrades = {
		"hull": 0,
		"blaster": 0,
		"laser_damage": 0,
		"laser_speed": 0,
		"engine": 0,
		"thrusters": 0,
		"magnet": 0,
		"aux_fire_rate": 0,
		"aux_damage": 0,
		"aux_range": 0,
		"aux_laser_speed": 0,
	}
	artifact_parts_collected = 0
	artifact_completed = false
	artifact_parts = {
		"vacuum": 0,
		"reverse_thruster": 0,
	}
	unlocked_artifacts = PackedStringArray([])
	# Comeca com o Vacuum desbloqueado (tutorial de quebra).
	unlocked_artifacts.append("vacuum")
	current_zone_id = "outer"
	unlocked_zones = PackedStringArray(["outer"])
	visited_zones = PackedStringArray([])
	_recalculate_player_stats()
	player_health = player_max_health
	alien_max_health = BASE_ALIEN_MAX_HEALTH
	alien_health = alien_max_health
	consumables = {"repair_kit": 0}
	_regen_cooldown = 0.0
	_regen_accum = 0.0
	boss_planet_resources_unlocked = false
	discovered_station_ids = PackedStringArray(["station_epsilon"])
	alpha_station_map_bought = false
	kappa_station_map_bought = false
	beta_station_map_bought = false
	zeta_station_map_bought = false
	defeated_bosses = []
	zone2_intro_station_local = Vector2.ZERO
	zone2_drill_given = false
	mining_drill_part_local = Vector2.ZERO
	vacuum_map_bought = false
	vacuum_random_part_local = Vector2.ZERO
	vacuum_random_part_world = Vector2.ZERO
	vacuum_random_part_collected = false
	vacuum_shop_part_bought = false
	vacuum_intro_uses_left = 30
	vacuum_broken_once = false
	vacuum_is_broken = false
	mid_core_event_triggered = false
	mid_core_patrol_cleared = false
	reverse_thruster_map_bought = false
	reverse_thruster_random_part_local = Vector2.ZERO
	reverse_thruster_random_part_world = Vector2.ZERO
	reverse_thruster_random_part_collected = false
	reverse_thruster_shop_parts_bought = {}
	side_dash_map_unlocked = false
	side_dash_random_part_local = Vector2.ZERO
	side_dash_random_part_world = Vector2.ZERO
	side_dash_random_part_collected = false
	side_dash_shop_parts_bought = {}
	auto_regen_map_zone1_bought = false
	auto_regen_map_zone2_bought = false
	auto_regen_part1_local = Vector2.ZERO
	auto_regen_part1_world = Vector2.ZERO
	auto_regen_part1_collected = false
	auto_regen_part2_local = Vector2.ZERO
	auto_regen_part2_world = Vector2.ZERO
	auto_regen_part2_collected = false
	aux_ship_map_unlocked = false
	aux_ship_random_part_local = Vector2.ZERO
	aux_ship_random_part_world = Vector2.ZERO
	aux_ship_random_part_collected = false
	aux_ship_shop_part_bought = false
	last_quest_claim_time = 0.0
	last_upgrade_time = 0.0
	last_artifact_unlock_time = 0.0
	last_resource_gain_time = 0.0
	last_enemy_kill_time = 0.0
	session_start_time = Time.get_ticks_msec() / 1000.0

func queue_save() -> void:
	_queue_save()

func debug_unlock_all_gadgets() -> void:
	# Helper de debug: desbloqueia todos os gadgets (nao inclui relíquias de viagem).
	for artifact_id_variant in ArtifactDatabase.ARTIFACTS.keys():
		var artifact_id := str(artifact_id_variant)
		var required: int = ArtifactDatabase.get_parts_required(artifact_id)
		if required <= 0:
			continue
		artifact_parts[artifact_id] = required
		if not unlocked_artifacts.has(artifact_id):
			unlocked_artifacts.append(artifact_id)
			# Mostrar balão de fala quando desbloqueia um artefato
			var artifact_title := ArtifactDatabase.get_artifact_title(artifact_id)
			var artifact_description := ArtifactDatabase.get_artifact_description(artifact_id)
			emit_signal("speech_requested", "Uau arranjei %s!" % artifact_title)

			# Mostrar descrição 5 segundos depois
			if not artifact_description.is_empty():
				get_tree().create_timer(5.0).timeout.connect(func():
					emit_signal("speech_requested", artifact_description)
				)

	# Garantias especificas.
	vacuum_is_broken = false
	vacuum_broken_once = true
	vacuum_intro_uses_left = 0

	emit_signal("state_changed")
	_queue_save()

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
	var old_max := player_max_health
	player_max_health = BASE_PLAYER_MAX_HEALTH + get_upgrade_level("hull") * 10
	var health_increase := player_max_health - old_max
	if health_increase > 0:
		player_health += health_increase
	player_health = clamp(player_health, 0, player_max_health)

func _queue_save() -> void:
	if _save_queued:
		return
	_save_queued = true
	call_deferred("_flush_save")

func _flush_save() -> void:
	_save_queued = false
	save_game()
