extends Node

# VALORES DE PRODUÇÃO
const IDLE_TIME_THRESHOLD := 120.0  # 2 min sem progresso
const HINT_COOLDOWN := 60.0  # 1 min entre hints
const CHECK_INTERVAL := 15.0  # Verifica a cada 15s
const VACUUM_BREAK_HINT_DELAY := 30.0  # 30s após aspirador partir

const MAX_HINT_HISTORY := 10
const SAVE_PATH := "user://hint_system.json"

const HINTS := {
	# Early game
	"early_low_resources": [
		"Destrói cometas e inimigos para ganhar recursos.",
		"Procura cometas pelo espaço para minerar recursos.",
		"Explora a zona para encontrar cometas com scrap e mineral.",
	],
	"early_no_quests": [
		"Visita estações e fala com NPCs para aceitar missões.",
		"As missões dão recompensas úteis. Vai a uma estação!",
	],
	"early_can_upgrade": [
		"Tens recursos suficientes! Melhora a nave (tecla U).",
		"Upgrades tornam-te mais forte. Abre o menu (U).",
	],
	"early_need_artifacts": [
		"Procura partes de artefactos nas estações.",
		"Artefactos desbloqueiam novas habilidades!",
	],

	# Mid game
	"mid_low_resources": [
		"Precisas de mais recursos. Explora a zona!",
		"Procura ametistas em cometas especiais (precisas da broca).",
	],
	"mid_missing_artifacts": [
		"Procura partes de artefactos para desbloquear habilidades.",
		"Verifica as estações para comprar partes.",
	],
	"mid_stuck_zone": [
		"Coleta artefactos para desbloquear a próxima zona.",
		"Precisas de artefactos para avançar!",
	],
	"mid_can_upgrade": [
		"Melhora a nave antes de zonas mais difíceis!",
		"Tens recursos. Investe em upgrades (U).",
	],

	# Late game
	"late_boss_prep": [
		"O boss final é muito difícil. Prepara-te bem!",
		"Certifica-te que tens todos os upgrades.",
	],
	"late_missing_artifacts": [
		"Regeneração automática é útil no boss final!",
		"Alguns artefactos facilitam a luta.",
	],
	"late_low_health": [
		"Repara a nave antes de enfrentar o boss!",
	],

	# Universal
	"check_quests": [
		"Verifica as missões (Tab) para ver progresso.",
	],
	"unclaimed_quests": [
		"Tens missões completas! Reclama recompensas.",
	],
	"explore_space": [
		"Explora o espaço para encontrar segredos.",
		"Há muito para descobrir. Continua a explorar!",
	],
	"stations_available": [
		"Procura estações no minimapa (M).",
	],
	"combat_tip": [
		"Usa dash (botões rato) para esquivar.",
	],

	# Tutorial - early game hints (usados por _select_best_hint nos primeiros 2 min)
	"tutorial_basic_movement": [
		"Usa W para andar para frente, A e D para virar.",
	],
	"tutorial_shooting": [
		"Pressiona Espaço para disparar lasers.",
	],
	"tutorial_collect_resources": [
		"Rebenta cometas para ganhar recursos!",
	],
	"tutorial_go_to_station": [
		"Vai a uma estação para aceitar missões.",
		"Abre o mapa (M) para ver estações.",
	],
}

var _last_hint_time: float = 0.0
var _timer: Timer
var _hint_history: Array[Dictionary] = []
var _tutorial_shown: bool = false
var _known_artifacts: PackedStringArray = PackedStringArray([])
var _vacuum_break_hint_shown: bool = false
var _vacuum_was_broken: bool = false

# Milestones de progressão (para não repetir hints)
var _milestones: Dictionary = {
	"first_quest_accepted": false,
	"first_upgrade": false,
	"first_quest_complete": false,
	"first_station_visit": false,  # Primeira visita a qualquer estação
	"visited_delta": false,
	"zone2_unlocked": false,
	"zone3_unlocked": false,
	"half_upgrades": false,  # Metade dos upgrades no máximo
}

func _ready() -> void:
	print("\n========================================")
	print("[HintSystem] INICIALIZANDO SISTEMA DE HINTS")
	print("========================================")
	print("[HintSystem] Idle threshold: ", IDLE_TIME_THRESHOLD, "s")
	print("[HintSystem] Hint cooldown: ", HINT_COOLDOWN, "s")
	print("[HintSystem] Check interval: ", CHECK_INTERVAL, "s")

	load_data()
	print("[HintSystem] Tutorial shown: ", _tutorial_shown)
	print("[HintSystem] Vacuum break hint shown: ", _vacuum_break_hint_shown)
	print("[HintSystem] Milestones: ", _milestones)

	_timer = Timer.new()
	_timer.wait_time = CHECK_INTERVAL
	_timer.timeout.connect(_check_idle_state)
	_timer.autostart = true
	add_child(_timer)

	# Conectar ao sinal de mudança de estado para detectar novos artefactos
	GameState.state_changed.connect(_on_game_state_changed)

	# Conectar ao sinal de morte do jogador
	GameState.player_died.connect(_on_player_died)

	# Conectar ao sinal de entrada em estação
	GameState.station_entered.connect(_on_station_entered)

	print("[HintSystem] Sistema de hints pronto!")
	print("========================================\n")

	# Mostrar tutorial inicial após 3 segundos
	print("[HintSystem] Aguardando 3 segundos para mostrar tutorial...")
	await get_tree().create_timer(3.0).timeout
	print("[HintSystem] 3 segundos passaram, chamando _maybe_show_tutorial()...")
	_maybe_show_tutorial()

func _check_idle_state() -> void:
	var current_time := Time.get_ticks_msec() / 1000.0
	var idle_time := _calculate_idle_duration()
	var time_since_last_hint := current_time - _last_hint_time

	print("[HintSystem] Check - Idle: %.1fs / %.1fs | Last hint: %.1fs ago / %.1fs cooldown" % [idle_time, IDLE_TIME_THRESHOLD, time_since_last_hint, HINT_COOLDOWN])

	if time_since_last_hint < HINT_COOLDOWN:
		print("[HintSystem] -> Cooldown ativo, aguardando...")
		return

	if idle_time >= IDLE_TIME_THRESHOLD:
		print("[HintSystem] -> IDLE DETECTADO! Mostrando hint...")
		_show_hint()
		_last_hint_time = current_time
	else:
		print("[HintSystem] -> Jogador ativo, aguardando idle...")

func _calculate_idle_duration() -> float:
	var current_time := Time.get_ticks_msec() / 1000.0
	var last_progress: float = maxf(
		maxf(GameState.last_quest_claim_time, GameState.last_upgrade_time),
		maxf(maxf(GameState.last_artifact_unlock_time, GameState.last_resource_gain_time),
		GameState.last_enemy_kill_time)
	)

	if last_progress <= 0.0:
		last_progress = GameState.session_start_time

	return current_time - last_progress

func _get_game_phase() -> String:
	var zone: String = GameState.current_zone_id
	var artifacts: int = GameState.unlocked_artifacts.size()

	if zone == "outer" and artifacts < 3:
		return "early"
	elif zone == "mid" or (zone == "outer" and artifacts >= 3):
		return "mid"
	return "late"

func _has_low_resources() -> bool:
	return (GameState.resources.get("scrap", 0) < 50 and
	        GameState.resources.get("mineral", 0) < 20)

func _can_afford_any_upgrade() -> bool:
	for upgrade_id in GameState.upgrades.keys():
		var level: int = GameState.get_upgrade_level(upgrade_id)
		var max_level: int = GameState.get_upgrade_max_level(upgrade_id)
		if level >= max_level:
			continue
		if GameState.can_afford(GameState.get_upgrade_cost(upgrade_id)):
			return true
	return false

func _has_unclaimed_quests() -> bool:
	for quest_id_variant in GameState.quests.keys():
		var q: Dictionary = GameState.quests.get(str(quest_id_variant), {})
		if q.get("completed", false) and not q.get("claimed", false):
			return true
	return false

func _is_stuck_at_zone() -> bool:
	var current: String = GameState.current_zone_id
	if current == "outer":
		return not GameState.can_access_zone("mid")
	elif current == "mid":
		return not GameState.can_access_zone("core")
	return false

func _has_low_health() -> bool:
	return GameState.player_health < (GameState.player_max_health * 0.5)

func _analyze_player_state() -> Dictionary:
	return {
		"phase": _get_game_phase(),
		"has_low_resources": _has_low_resources(),
		"can_afford_upgrades": _can_afford_any_upgrade(),
		"has_unclaimed_quests": _has_unclaimed_quests(),
		"is_stuck_at_zone": _is_stuck_at_zone(),
		"has_low_health": _has_low_health(),
	}

func _select_best_hint(state: Dictionary) -> String:
	var phase_value = state.get("phase", "early")
	var phase: String = str(phase_value) if phase_value else "early"

	# INÍCIO DO JOGO - Prioridade máxima para ensinar mecânicas básicas
	var session_time: float = Time.get_ticks_msec() / 1000.0 - GameState.session_start_time

	# Primeiros 2 minutos de jogo - ensinar controlos básicos
	if session_time < 120.0:
		# Jogador não se mexeu muito ainda
		if GameState.last_resource_gain_time <= 0.0 and GameState.last_enemy_kill_time <= 0.0:
			return "tutorial_basic_movement"

		# Jogador não disparou ainda
		if GameState.last_enemy_kill_time <= 0.0:
			return "tutorial_shooting"

		# Jogador ainda não tem muitos recursos
		if GameState.resources.get("scrap", 0) < 20:
			return "tutorial_collect_resources"

		# Jogador não aceitou nenhuma quest
		if not _milestones["first_quest_accepted"]:
			return "tutorial_go_to_station"

	# URGENTE - sempre tem prioridade
	if state["has_unclaimed_quests"]:
		return "unclaimed_quests"
	if state["has_low_health"] and phase == "late":
		return "late_low_health"

	# BLOQUEIOS - segunda prioridade
	if state["is_stuck_at_zone"]:
		return phase + "_stuck_zone" if phase != "early" else "early_need_artifacts"

	# PROGRESSÃO - terceira prioridade
	if state["has_low_resources"]:
		return phase + "_low_resources"
	if state["can_afford_upgrades"]:
		return phase + "_can_upgrade"

	# POR FASE
	if phase == "late":
		return "late_boss_prep"

	# FALLBACK - hints genéricos
	return "explore_space"

func _was_hint_shown_recently(hint_id: String, cooldown_min: float = 0.13) -> bool:  # TESTE: 0.13 min = 8s (era 8.0 min)
	var current := Time.get_ticks_msec() / 1000.0
	var cooldown := cooldown_min * 60.0

	for entry in _hint_history:
		if entry["hint_id"] == hint_id and current - entry["time"] < cooldown:
			return true
	return false

func _mark_hint_shown(hint_id: String) -> void:
	_hint_history.append({
		"hint_id": hint_id,
		"time": Time.get_ticks_msec() / 1000.0
	})

	if _hint_history.size() > MAX_HINT_HISTORY:
		_hint_history.remove_at(0)

func _select_fallback_hint(state: Dictionary) -> String:
	var generic := ["explore_space", "stations_available", "combat_tip"]
	for hint_id in generic:
		if not _was_hint_shown_recently(hint_id, 0.08):  # TESTE: 0.08 min = 5s (era 5.0 min)
			return hint_id
	return ""

func _get_random_hint_text(hint_id: String) -> String:
	var hints_array: Array = HINTS.get(hint_id, [])
	if hints_array.is_empty():
		return ""
	return hints_array[randi() % hints_array.size()]

func _show_hint() -> void:
	print("[HintSystem] _show_hint() chamado")
	var state := _analyze_player_state()
	print("[HintSystem] Estado analisado: ", state)

	var hint_id := _select_best_hint(state)
	print("[HintSystem] Hint selecionado: ", hint_id)

	if _was_hint_shown_recently(hint_id):
		print("[HintSystem] Hint '", hint_id, "' foi mostrado recentemente, procurando fallback...")
		hint_id = _select_fallback_hint(state)
		print("[HintSystem] Fallback selecionado: ", hint_id)

	if hint_id.is_empty():
		print("[HintSystem] ERRO: Nenhum hint disponível!")
		return

	var hint_text := _get_random_hint_text(hint_id)
	print("[HintSystem] Texto do hint: ", hint_text)

	if not hint_text.is_empty():
		print("[HintSystem] Emitindo sinal 'speech_requested' com texto: ", hint_text)
		GameState.emit_signal("speech_requested", hint_text)
		_mark_hint_shown(hint_id)
		save_data()
		print("[HintSystem] Hint enviado com sucesso!")
	else:
		print("[HintSystem] ERRO: Texto do hint vazio!")

func save_data() -> void:
	var data := {
		"last_hint_time": _last_hint_time,
		"hint_history": _hint_history,
		"tutorial_shown": _tutorial_shown,
		"vacuum_break_hint_shown": _vacuum_break_hint_shown,
		"milestones": _milestones,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))

func reset_all() -> void:
	print("[HintSystem] RESET COMPLETO - Novo jogo iniciado!")
	_tutorial_shown = false
	_vacuum_break_hint_shown = false
	_vacuum_was_broken = false
	_known_artifacts.clear()
	_hint_history.clear()
	_last_hint_time = 0.0
	_milestones = {
		"first_quest_accepted": false,
		"first_upgrade": false,
		"first_quest_complete": false,
		"first_station_visit": false,
		"visited_delta": false,
		"zone2_unlocked": false,
		"zone3_unlocked": false,
		"half_upgrades": false,
	}
	save_data()
	print("[HintSystem] Reset concluído!")

	# Agendar tutorial para novo jogo (após a cena carregar)
	print("[HintSystem] Agendando tutorial para novo jogo...")
	await get_tree().create_timer(3.0).timeout
	_maybe_show_tutorial()

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("[HintSystem] Nenhum save encontrado, usando defaults")
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return

	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		var data: Dictionary = parsed
		_last_hint_time = float(data.get("last_hint_time", 0.0))
		_tutorial_shown = bool(data.get("tutorial_shown", false))
		_vacuum_break_hint_shown = bool(data.get("vacuum_break_hint_shown", false))

		var loaded_milestones = data.get("milestones")
		if typeof(loaded_milestones) == TYPE_DICTIONARY:
			for key in loaded_milestones.keys():
				_milestones[key] = bool(loaded_milestones[key])

		var loaded = data.get("hint_history")
		if typeof(loaded) == TYPE_ARRAY:
			_hint_history.clear()
			for entry in loaded:
				if typeof(entry) == TYPE_DICTIONARY:
					_hint_history.append(entry)

func _maybe_show_tutorial() -> void:
	print("[HintSystem] _maybe_show_tutorial() foi chamado!")
	print("[HintSystem] _tutorial_shown = ", _tutorial_shown)
	print("[HintSystem] current_zone_id = ", GameState.current_zone_id)

	# Só mostra tutorial se for a primeira vez
	if _tutorial_shown:
		print("[HintSystem] AVISO: Tutorial já foi mostrado anteriormente, abortando...")
		return

	# Verificar se o player está na zona inicial (outer)
	if GameState.current_zone_id != "outer":
		print("[HintSystem] AVISO: Não está na zona outer, abortando...")
		return

	_tutorial_shown = true
	save_data()

	print("[HintSystem] *** MOSTRANDO TUTORIAL INICIAL ***")

	# Introdução - contexto do jogo
	var intro_messages := [
		"Sou o Ricky. Fui trazido para este espaço desconhecido...",
		"Tenho de explorar e melhorar a nave com artefactos, gadgets e upgrades.",
		"Para depois conseguir derrotar o grande vilão!",
	]

	# Controlos básicos
	var control_messages := [
		"W acelera, A/D vira, Espaço dispara.",
		"Destrói cometas e naves para recursos.",
	]

	# Mostrar introdução
	for msg in intro_messages:
		print("[HintSystem] Intro: ", msg)
		GameState.emit_signal("speech_requested", msg)
		await get_tree().create_timer(5.0).timeout

	# Pequena pausa
	await get_tree().create_timer(2.0).timeout

	# Mostrar controlos
	for i in range(control_messages.size()):
		var msg = control_messages[i]
		print("[HintSystem] Controlo: ", msg)
		GameState.emit_signal("speech_requested", msg)
		if i < control_messages.size() - 1:
			await get_tree().create_timer(5.0).timeout

	print("[HintSystem] *** TUTORIAL ENVIADO COM SUCESSO ***")

func _on_game_state_changed() -> void:
	# Verificar se o aspirador partiu
	if GameState.vacuum_broken_once and not _vacuum_was_broken and not _vacuum_break_hint_shown:
		_vacuum_was_broken = true
		_schedule_vacuum_break_hint()

	# Verificar milestones de progressão
	_check_progression_milestones()

	# Verificar se há novos artefactos desbloqueados
	for artifact_id in GameState.unlocked_artifacts:
		if not _known_artifacts.has(artifact_id):
			_known_artifacts.append(artifact_id)
			_show_artifact_tutorial(artifact_id)

func _check_progression_milestones() -> void:
	# Primeira quest aceite
	if not _milestones["first_quest_accepted"]:
		for quest_id_variant in GameState.quests.keys():
			var q: Dictionary = GameState.quests.get(str(quest_id_variant), {})
			if q.get("accepted", false):
				_milestones["first_quest_accepted"] = true
				save_data()
				_schedule_first_quest_hint()
				break

	# NOTA: visited_delta agora é tratado em _on_station_entered()

	# Primeiro upgrade
	if not _milestones["first_upgrade"]:
		var has_upgrade := false
		for upgrade_id in GameState.upgrades.keys():
			if GameState.get_upgrade_level(upgrade_id) > 0:
				has_upgrade = true
				break
		if has_upgrade:
			_milestones["first_upgrade"] = true
			save_data()
			GameState.emit_signal("speech_requested", "Boa! A nave está mais forte agora!")

	# Primeira quest completa (objectivo cumprido, mas ainda não reclamou)
	if not _milestones["first_quest_complete"]:
		for quest_id_variant in GameState.quests.keys():
			var q: Dictionary = GameState.quests.get(str(quest_id_variant), {})
			if q.get("completed", false) and not q.get("claimed", false):
				_milestones["first_quest_complete"] = true
				save_data()
				GameState.emit_signal("speech_requested", "Primeira missão completa!")
				await get_tree().create_timer(5.0).timeout
				GameState.emit_signal("speech_requested", "Vai recolher a tua recompensa. Usa Tab para ver como.")
				break

	# Zona 2 desbloqueada
	if not _milestones["zone2_unlocked"] and GameState.can_access_zone("mid"):
		_milestones["zone2_unlocked"] = true
		save_data()
		_schedule_zone2_hint()

	# Zona 3 desbloqueada
	if not _milestones["zone3_unlocked"] and GameState.can_access_zone("core"):
		_milestones["zone3_unlocked"] = true
		save_data()
		_schedule_zone3_hint()

	# Metade dos upgrades completos
	if not _milestones["half_upgrades"]:
		var avg_level: float = GameState.get_average_ship_upgrade_level()
		if avg_level >= 5.0:
			_milestones["half_upgrades"] = true
			save_data()
			GameState.emit_signal("speech_requested", "A nave está bem equipada!")
			GameState.emit_signal("speech_requested", "Continua a melhorar para zonas mais difíceis.")

func _schedule_first_quest_hint() -> void:
	await get_tree().create_timer(10.0).timeout
	GameState.emit_signal("speech_requested", "Um novo refúgio foi adicionado ao mapa!")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Usa Tab para ver as missões e inventário.")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Dentro de um refúgio, clica U para dar upgrade à nave.")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Explora o espaço!")

func _schedule_zone2_hint() -> void:
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Desbloqueaste a Zona 2!")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Abre o mapa (M) para mudar de zona.")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "A Zona 2 é mais difícil. Prepara-te bem!")

func _schedule_zone3_hint() -> void:
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Zona 3 desbloqueada - o núcleo!")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Abre o mapa (M) para mudar de zona.")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "O boss final está lá. Prepara-te muito bem!")

func _schedule_vacuum_break_hint() -> void:
	print("[HintSystem] Aspirador partiu! Agendando hint para ", VACUUM_BREAK_HINT_DELAY, "s...")
	await get_tree().create_timer(VACUUM_BREAK_HINT_DELAY).timeout

	if _vacuum_break_hint_shown:
		return

	_vacuum_break_hint_shown = true
	save_data()

	print("[HintSystem] Mostrando hint após aspirador partir...")
	GameState.emit_signal("speech_requested", "Bolas, parece que o aspirador partiu.")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Agora, para apanhar recursos, temos de sair da nave (F).")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Para voltar à nave, fica a pressionar F perto dela.")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Abre o mapa (M) e segue para o Refúgio Epsilon.")

func _on_player_died() -> void:
	print("[HintSystem] Jogador morreu!")
	GameState.emit_signal("speech_requested", "Ah, morri. Perdi os recursos que não tinha no cofre.")
	await get_tree().create_timer(5.0).timeout
	GameState.emit_signal("speech_requested", "Vamos tentar outra vez!")

func _show_artifact_tutorial(artifact_id: String) -> void:
	print("[HintSystem] Novo artefacto desbloqueado: ", artifact_id)

	match artifact_id:
		"reverse_thruster":
			GameState.emit_signal("speech_requested", "Agora podes andar para trás!")
			GameState.emit_signal("speech_requested", "Usa S para reverter.")
		"side_dash":
			GameState.emit_signal("speech_requested", "Desbloqueaste o dash lateral melhorado!")
		"aux_ship":
			GameState.emit_signal("speech_requested", "A nave auxiliar vai ajudar-te nos combates!")
		"mining_drill":
			GameState.emit_signal("speech_requested", "Com a broca podes minerar ametistas!")
			GameState.emit_signal("speech_requested", "Procura cometas especiais no espaço.")
		"auto_regen":
			GameState.emit_signal("speech_requested", "A regeneração automática vai curar-te aos poucos!")
		"vacuum":
			# Vacuum está disponível no início, não precisa de tutorial extra
			pass

func _on_station_entered(station_id: String) -> void:
	print("[HintSystem] Jogador entrou na estação: ", station_id)

	# Primeira visita a qualquer estação - avisar para falar com NPCs
	if not _milestones["first_station_visit"]:
		_milestones["first_station_visit"] = true
		save_data()
		await get_tree().create_timer(5.0).timeout
		GameState.emit_signal("speech_requested", "Fala com os NPCs para aceitar missões e comprar artefactos.")
		return  # Não mostrar outras mensagens na primeira visita

	# Chegou ao Mercador Delta pela primeira vez
	if station_id == "station_delta" and not _milestones["visited_delta"]:
		_milestones["visited_delta"] = true
		save_data()
		await get_tree().create_timer(5.0).timeout
		GameState.emit_signal("speech_requested", "Chegaste ao Mercador Delta!")
		await get_tree().create_timer(5.0).timeout
		GameState.emit_signal("speech_requested", "Procura a taberna para enfrentar o bandido.")
