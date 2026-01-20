extends Control

@onready var health_label: Label = $HealthContainer/HealthLabel
@onready var alien_health_label: Label = $AlienHealthContainer/AlienHealthLabel
@onready var scrap_label: Label = $ResourcesContainer/ResourcesBox/ScrapLabel
@onready var mineral_label: Label = $ResourcesContainer/ResourcesBox/MineralLabel
@onready var ametista_label: Label = $ResourcesContainer/ResourcesBox/AmetistaLabel

@onready var upgrade_menu: Control = $UpgradeMenu
@onready var upgrade_info: Label = $UpgradeMenu/Panel/Margin/VBox/Info
@onready var upgrade_description: RichTextLabel = $UpgradeMenu/Panel/Margin/VBox/UpgradeDescription

@onready var hull_button: Button = $UpgradeMenu/Panel/Margin/VBox/HullButton
@onready var blaster_button: Button = $UpgradeMenu/Panel/Margin/VBox/BlasterButton
@onready var engine_button: Button = $UpgradeMenu/Panel/Margin/VBox/EngineButton
@onready var thrusters_button: Button = $UpgradeMenu/Panel/Margin/VBox/ThrustersButton
@onready var magnet_button: Button = $UpgradeMenu/Panel/Margin/VBox/MagnetButton

@onready var reset_button: Button = $UpgradeMenu/Panel/Margin/VBox/ResetButton
@onready var close_button: Button = $UpgradeMenu/Panel/Margin/VBox/CloseButton

@onready var map_menu: Control = $MapMenu
@onready var map_zone_list: VBoxContainer = $MapMenu/Panel/Margin/VBox/ZoneList
@onready var close_map_button: Button = $MapMenu/Panel/Margin/VBox/CloseMapButton

@onready var trader_menu: Control = $TraderMenu
@onready var trader_info: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/Info
@onready var scrap_to_mineral_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/ScrapToMineralButton
@onready var mineral_to_scrap_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/MineralToScrapButton
@onready var buy_artifact_part_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyArtifactPartButton
@onready var ametista_to_mineral_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/AmetistaToMineralButton
@onready var ametista_to_scrap_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/AmetistaToScrapButton

@onready var npc1_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/NPC1Button
@onready var npc2_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/NPC2Button
@onready var npc3_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/NPC3Button
@onready var accept_kill_quest_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/AcceptKillQuestButton
@onready var claim_station_quest_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/ClaimStationQuestButton
@onready var dialogue_text: RichTextLabel = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/DialogueText
@onready var dialogue_choices: VBoxContainer = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/DialogueChoices
@onready var end_dialogue_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/EndDialogueButton
@onready var open_upgrades_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mecanico/OpenUpgradesButton

@onready var close_trader_button: Button = $TraderMenu/Panel/Margin/VBox/CloseTraderButton

@onready var missions_menu: Control = $MissionsMenu
@onready var missions_tabs: TabContainer = $MissionsMenu/Panel/Margin/VBox/Tabs
@onready var missions_list: VBoxContainer = $MissionsMenu/Panel/Margin/VBox/Tabs/Missoes/MissionList
@onready var inventory_list: VBoxContainer = $MissionsMenu/Panel/Margin/VBox/Tabs/Inventario/InventoryList
@onready var close_missions_button: Button = $MissionsMenu/Panel/Margin/VBox/CloseMissionsButton

const DEFAULT_STATION_ID := "station_alpha"

var _upgrade_buttons: Dictionary
var _active_trader: Node = null
var _active_station: Node = null
var _active_station_id: String = ""
var _offered_quest_id: String = ""
var _dialogue_state: Dictionary = {}
var _station_npcs: Array = []
var _menu_guard: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("hud")

	_upgrade_buttons = {
		"hull": hull_button,
		"blaster": blaster_button,
		"engine": engine_button,
		"thrusters": thrusters_button,
		"magnet": magnet_button,
	}

	for upgrade_id in _upgrade_buttons.keys():
		var button: Button = _upgrade_buttons[upgrade_id]
		button.pressed.connect(_on_upgrade_pressed.bind(upgrade_id))
		button.mouse_entered.connect(_on_upgrade_hovered.bind(upgrade_id))
		button.mouse_exited.connect(_on_upgrade_unhovered)

	reset_button.pressed.connect(_on_reset_pressed)
	close_button.pressed.connect(_on_close_pressed)
	close_map_button.pressed.connect(_on_close_map_pressed)
	close_trader_button.pressed.connect(_on_close_trader_pressed)
	close_missions_button.pressed.connect(_on_close_missions_pressed)

	scrap_to_mineral_button.pressed.connect(_on_trade_scrap_to_mineral)
	mineral_to_scrap_button.pressed.connect(_on_trade_mineral_to_scrap)
	buy_artifact_part_button.pressed.connect(_on_buy_artifact_part)
	ametista_to_mineral_button.pressed.connect(_on_trade_ametista_to_mineral)
	ametista_to_scrap_button.pressed.connect(_on_trade_ametista_to_scrap)
	npc1_button.pressed.connect(_on_npc_pressed.bind(0))
	npc2_button.pressed.connect(_on_npc_pressed.bind(1))
	npc3_button.pressed.connect(_on_npc_pressed.bind(2))
	accept_kill_quest_button.pressed.connect(_on_accept_kill_quest)
	claim_station_quest_button.pressed.connect(_on_claim_station_quest)
	open_upgrades_button.pressed.connect(_on_open_upgrades_pressed)
	end_dialogue_button.pressed.connect(_end_dialogue)

	GameState.state_changed.connect(_update_hud)
	_update_hud()

func _process(_delta: float) -> void:
	# fallback: nada aqui (TAB é capturado em _input)
	pass

func _input(event: InputEvent) -> void:
	# TAB direto (funciona mesmo sem InputMap)
	if event is InputEventKey and (event as InputEventKey).pressed and not (event as InputEventKey).echo:
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_TAB:
			_set_missions_menu_visible(not missions_menu.visible)
			get_viewport().set_input_as_handled()
			return

	# Se existir no InputMap, também aceita por ação.
	if InputMap.has_action("open_missions") and event.is_action_pressed("open_missions"):
		_set_missions_menu_visible(not missions_menu.visible)
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and _active_trader != null and not trader_menu.visible:
		_set_trader_menu_visible(true)
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("open_upgrades"):
		if _active_station != null:
			_set_upgrade_menu_visible(not upgrade_menu.visible)
			get_viewport().set_input_as_handled()
		return

	if event is InputEventKey and (event as InputEventKey).pressed and not (event as InputEventKey).echo:
		var key_event := event as InputEventKey
		if key_event.keycode == KEY_M:
			_set_map_menu_visible(not map_menu.visible)
			get_viewport().set_input_as_handled()
			return

	if upgrade_menu.visible and event.is_action_pressed("ui_cancel"):
		_set_upgrade_menu_visible(false)
		get_viewport().set_input_as_handled()
		return

	if map_menu.visible and event.is_action_pressed("ui_cancel"):
		_set_map_menu_visible(false)
		get_viewport().set_input_as_handled()
		return

	if trader_menu.visible and event.is_action_pressed("ui_cancel"):
		_set_trader_menu_visible(false)
		get_viewport().set_input_as_handled()
		return

	if missions_menu.visible and event.is_action_pressed("ui_cancel"):
		_set_missions_menu_visible(false)
		get_viewport().set_input_as_handled()
		return

func _set_upgrade_menu_visible(visible: bool) -> void:
	if _menu_guard:
		return
	_menu_guard = true
	upgrade_menu.visible = visible
	if visible:
		map_menu.visible = false
		trader_menu.visible = false
		missions_menu.visible = false
	_menu_guard = false
	_apply_pause_from_menus()
	if visible:
		_on_upgrade_unhovered()
	_update_hud()

func _set_map_menu_visible(visible: bool) -> void:
	if _menu_guard:
		return
	_menu_guard = true
	map_menu.visible = visible
	if visible:
		upgrade_menu.visible = false
		trader_menu.visible = false
		missions_menu.visible = false
		_rebuild_map_zone_list()
	_menu_guard = false
	_apply_pause_from_menus()
	_update_hud()

func _set_trader_menu_visible(visible: bool) -> void:
	if _menu_guard:
		return
	_menu_guard = true
	trader_menu.visible = visible
	if visible:
		upgrade_menu.visible = false
		map_menu.visible = false
		missions_menu.visible = false
	_menu_guard = false
	_apply_pause_from_menus()
	_update_hud()
	if visible:
		_end_dialogue()

func _set_missions_menu_visible(visible: bool) -> void:
	if _menu_guard:
		return
	_menu_guard = true
	missions_menu.visible = visible
	if visible:
		upgrade_menu.visible = false
		map_menu.visible = false
		trader_menu.visible = false
		_rebuild_missions_list()
		_rebuild_inventory_list()
	_menu_guard = false
	_apply_pause_from_menus()
	_update_hud()

func _apply_pause_from_menus() -> void:
	get_tree().paused = upgrade_menu.visible or map_menu.visible or trader_menu.visible or missions_menu.visible

func _update_hud() -> void:
	var hp: int = GameState.player_health
	var max_hp: int = GameState.player_max_health
	health_label.text = "HP: %d / %d" % [hp, max_hp]

	var alien_hp: int = GameState.alien_health
	var alien_max_hp: int = GameState.alien_max_health
	alien_health_label.text = "Alien: %d / %d" % [alien_hp, alien_max_hp]

	var scrap: int = int(GameState.resources.get("scrap", 0))
	var mineral: int = int(GameState.resources.get("mineral", 0))
	var ametista: int = int(GameState.resources.get("ametista", 0))
	scrap_label.text = "Scrap: %d" % scrap
	mineral_label.text = " | Mineral: %d" % mineral
	ametista_label.text = " | Ametista: %d" % ametista

	if upgrade_menu.visible:
		_update_upgrade_menu(scrap, mineral)

	if map_menu.visible:
		_rebuild_map_zone_list()

	if trader_menu.visible:
		_update_trader_menu(scrap, mineral)

	if missions_menu.visible:
		_rebuild_missions_list()
		_rebuild_inventory_list()

func _update_upgrade_menu(scrap: int, mineral: int) -> void:
	upgrade_info.text = "Scrap: %d | Mineral: %d | (U) Fechar" % [scrap, mineral]

	for upgrade_id in _upgrade_buttons.keys():
		var button: Button = _upgrade_buttons[upgrade_id]

		var title := GameState.get_upgrade_title(upgrade_id)
		var level := GameState.get_upgrade_level(upgrade_id)
		var max_level := GameState.get_upgrade_max_level(upgrade_id)

		if level >= max_level:
			button.text = "%s (MAX)" % title
			button.disabled = true
			continue

		var cost := GameState.get_upgrade_cost(upgrade_id)
		button.text = "%s  Lv %d/%d  -  %s" % [title, level, max_level, _format_cost(cost)]
		button.disabled = not GameState.can_afford(cost)

func _format_cost(cost: Dictionary) -> String:
	var parts: Array[String] = []
	if cost.has("scrap"):
		parts.append("Scrap:%d" % int(cost["scrap"]))
	if cost.has("mineral"):
		parts.append("Mineral:%d" % int(cost["mineral"]))
	if cost.has("ametista"):
		parts.append("Ametista:%d" % int(cost["ametista"]))
	return " | ".join(parts)

func _on_upgrade_pressed(upgrade_id: String) -> void:
	GameState.buy_upgrade(upgrade_id)

func _on_upgrade_hovered(upgrade_id: String) -> void:
	var title := GameState.get_upgrade_title(upgrade_id)
	var level := GameState.get_upgrade_level(upgrade_id)
	var max_level := GameState.get_upgrade_max_level(upgrade_id)
	var desc := GameState.get_upgrade_description(upgrade_id)
	upgrade_description.text = "%s (Lv %d/%d)\n%s" % [title, level, max_level, desc]

func _on_upgrade_unhovered() -> void:
	upgrade_description.text = "Passa o rato por cima de um upgrade."

func _on_reset_pressed() -> void:
	GameState.reset_save()
	_set_upgrade_menu_visible(false)
	get_tree().reload_current_scene()

func _on_close_pressed() -> void:
	_set_upgrade_menu_visible(false)

func _on_close_map_pressed() -> void:
	_set_map_menu_visible(false)

func _on_close_trader_pressed() -> void:
	_set_trader_menu_visible(false)

func _on_close_missions_pressed() -> void:
	_set_missions_menu_visible(false)

func register_trader_in_range(trader: Node, in_range: bool) -> void:
	if in_range:
		_active_trader = trader
	else:
		if _active_trader == trader:
			_active_trader = null
			if trader_menu.visible:
				_set_trader_menu_visible(false)

func register_station_in_range(station: Node, station_id: String, in_range: bool) -> void:
	if in_range:
		_active_station = station
		_active_station_id = station_id
	else:
		if _active_station == station:
			_active_station = null
			_active_station_id = ""
			if upgrade_menu.visible:
				_set_upgrade_menu_visible(false)
			if trader_menu.visible:
				_set_trader_menu_visible(false)

func _update_trader_menu(scrap: int, mineral: int) -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID

	var trades: Dictionary = StationCatalog.get_trades(station_id)
	var artifact_cost: Dictionary = StationCatalog.get_artifact_part_cost(station_id)

	var parts := "%d/%d" % [GameState.artifact_parts_collected, GameState.ARTIFACT_PARTS_REQUIRED]
	trader_info.text = "%s\nScrap: %d | Mineral: %d | Partes: %s" % [
		StationCatalog.get_station_title(station_id),
		scrap,
		mineral,
		parts
	]

	var s2m: Dictionary = trades.get("scrap_to_mineral", {}) as Dictionary
	var m2s: Dictionary = trades.get("mineral_to_scrap", {}) as Dictionary
	var a2m: Dictionary = trades.get("ametista_to_mineral", {}) as Dictionary
	var a2s: Dictionary = trades.get("ametista_to_scrap", {}) as Dictionary
	var s2m_give: Dictionary = s2m.get("give", {}) as Dictionary
	var s2m_recv: Dictionary = s2m.get("receive", {}) as Dictionary
	var m2s_give: Dictionary = m2s.get("give", {}) as Dictionary
	var m2s_recv: Dictionary = m2s.get("receive", {}) as Dictionary

	scrap_to_mineral_button.text = "Trocar %s -> %s" % [_format_cost(s2m_give), _format_cost(s2m_recv)]
	mineral_to_scrap_button.text = "Trocar %s -> %s" % [_format_cost(m2s_give), _format_cost(m2s_recv)]
	buy_artifact_part_button.text = "Comprar parte (%s)" % _format_cost(artifact_cost)

	var a2m_give: Dictionary = a2m.get("give", {}) as Dictionary
	var a2m_recv: Dictionary = a2m.get("receive", {}) as Dictionary
	var a2s_give: Dictionary = a2s.get("give", {}) as Dictionary
	var a2s_recv: Dictionary = a2s.get("receive", {}) as Dictionary

	var has_a2m := not a2m_give.is_empty() and not a2m_recv.is_empty()
	var has_a2s := not a2s_give.is_empty() and not a2s_recv.is_empty()
	ametista_to_mineral_button.visible = has_a2m
	ametista_to_scrap_button.visible = has_a2s
	if has_a2m:
		ametista_to_mineral_button.text = "Trocar %s -> %s" % [_format_cost(a2m_give), _format_cost(a2m_recv)]
		ametista_to_mineral_button.disabled = not GameState.can_afford(a2m_give)
	if has_a2s:
		ametista_to_scrap_button.text = "Trocar %s -> %s" % [_format_cost(a2s_give), _format_cost(a2s_recv)]
		ametista_to_scrap_button.disabled = not GameState.can_afford(a2s_give)

	scrap_to_mineral_button.disabled = not GameState.can_afford(s2m_give)
	mineral_to_scrap_button.disabled = not GameState.can_afford(m2s_give)

	var can_buy_part := (not GameState.artifact_completed) and GameState.can_afford(artifact_cost)
	buy_artifact_part_button.disabled = not can_buy_part

	var offered: Array = StationCatalog.get_offered_quests(station_id)
	_offered_quest_id = ""
	if offered.size() > 0:
		_offered_quest_id = str(offered[0])
	_update_station_quest_buttons()
	_update_npc_button_text()

func _on_trade_scrap_to_mineral() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var trades: Dictionary = StationCatalog.get_trades(station_id)
	var s2m: Dictionary = trades.get("scrap_to_mineral", {}) as Dictionary
	var give: Dictionary = s2m.get("give", {}) as Dictionary
	var receive: Dictionary = s2m.get("receive", {}) as Dictionary
	_apply_trade(give, receive)

func _on_trade_mineral_to_scrap() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var trades: Dictionary = StationCatalog.get_trades(station_id)
	var m2s: Dictionary = trades.get("mineral_to_scrap", {}) as Dictionary
	var give: Dictionary = m2s.get("give", {}) as Dictionary
	var receive: Dictionary = m2s.get("receive", {}) as Dictionary
	_apply_trade(give, receive)

func _on_buy_artifact_part() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_artifact_part_cost(station_id)
	GameState.try_buy_artifact_part(cost)

func _on_trade_ametista_to_mineral() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var trades: Dictionary = StationCatalog.get_trades(station_id)
	var t: Dictionary = trades.get("ametista_to_mineral", {}) as Dictionary
	var give: Dictionary = t.get("give", {}) as Dictionary
	var receive: Dictionary = t.get("receive", {}) as Dictionary
	_apply_trade(give, receive)

func _on_trade_ametista_to_scrap() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var trades: Dictionary = StationCatalog.get_trades(station_id)
	var t: Dictionary = trades.get("ametista_to_scrap", {}) as Dictionary
	var give: Dictionary = t.get("give", {}) as Dictionary
	var receive: Dictionary = t.get("receive", {}) as Dictionary
	_apply_trade(give, receive)

func _on_npc_pressed(index: int) -> void:
	if index < 0 or index >= _station_npcs.size():
		return
	var npc: Dictionary = _station_npcs[index] as Dictionary
	_start_dialogue(_active_station_id, str(npc.get("id", "")))

func _update_npc_button_text() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var title := StationCatalog.get_station_title(station_id)
	_station_npcs = _get_npcs_for_station(station_id)

	var buttons: Array[Button] = [npc1_button, npc2_button, npc3_button]
	for i in range(buttons.size()):
		var b := buttons[i]
		if i < _station_npcs.size():
			var npc: Dictionary = _station_npcs[i] as Dictionary
			b.visible = true
			b.disabled = false
			b.text = "%s (%s)" % [str(npc.get("name", "Alien")), title]
		else:
			b.visible = false

func _get_npcs_for_station(station_id: String) -> Array:
	match station_id:
		"station_alpha":
			return [
				{"id": "glip", "name": "Glip-Glop"},
				{"id": "zorbo", "name": "Zorbo o Pegajoso"},
				{"id": "mnem", "name": "Mnem-8"},
			]
		"station_delta":
			return [
				{"id": "krrth", "name": "Krr'th"},
				{"id": "bloop", "name": "Bloop"},
				{"id": "snee", "name": "Snee-Snack"},
			]
		"station_epsilon":
			return [
				{"id": "vexa", "name": "Vexa"},
				{"id": "oomu", "name": "Oomu"},
				{"id": "rrrl", "name": "Rrrl"},
			]
		_:
			return [
				{"id": "alien1", "name": "Alien Aleatorio"},
				{"id": "alien2", "name": "Alien Aleatorio 2"},
			]

func _start_dialogue(station_id_in: String, npc_id: String) -> void:
	var station_id := station_id_in
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID

	_dialogue_state = {"station_id": station_id, "npc_id": npc_id, "node": "start"}
	dialogue_text.bbcode_enabled = true
	end_dialogue_button.visible = true
	_render_dialogue()

func _render_dialogue() -> void:
	if dialogue_choices == null:
		return

	for child in dialogue_choices.get_children():
		dialogue_choices.remove_child(child)
		child.queue_free()

	var station_id := str(_dialogue_state.get("station_id", DEFAULT_STATION_ID))
	var npc_id := str(_dialogue_state.get("npc_id", ""))
	var node_id := str(_dialogue_state.get("node", "start"))

	var nodes := _get_dialogue_nodes(station_id, npc_id)
	var node: Dictionary = nodes.get(node_id, {}) as Dictionary
	if node.is_empty():
		dialogue_text.text = "..."
		end_dialogue_button.visible = false
		return

	dialogue_text.text = str(node.get("text", ""))
	var choices: Array = node.get("choices", []) as Array

	for choice_variant in choices:
		if typeof(choice_variant) != TYPE_DICTIONARY:
			continue
		var c: Dictionary = choice_variant
		var b := Button.new()
		b.text = str(c.get("text", ""))
		var next := str(c.get("next", ""))
		b.pressed.connect(_on_dialogue_choice.bind(next))
		dialogue_choices.add_child(b)

func _on_dialogue_choice(next_node: String) -> void:
	if next_node == "end":
		_end_dialogue()
		return
	_dialogue_state["node"] = next_node
	_render_dialogue()

func _end_dialogue() -> void:
	_dialogue_state = {}
	if dialogue_text != null:
		dialogue_text.text = ""
	if dialogue_choices != null:
		for child in dialogue_choices.get_children():
			dialogue_choices.remove_child(child)
			child.queue_free()
	if end_dialogue_button != null:
		end_dialogue_button.visible = false

func _get_dialogue_nodes(_station_id: String, npc_id: String) -> Dictionary:
	# Conversas engraçadas com escolhas.
	match npc_id:
		"glip":
			return {
				"start": {
					"text": "[b]Glip-Glop[/b]: Shh. Nao te mexas.\n[b]Tu[/b]: Porquê?\n[b]Glip-Glop[/b]: Se ficares quieto, os teus parafusos pensam que e feriado e param de cair.",
					"choices": [
						{"text": "Isso funciona mesmo?", "next": "works"},
						{"text": "Tens alguma fofoca?", "next": "gossip"},
						{"text": "Tchau.", "next": "end"},
					],
				},
				"works": {
					"text": "[b]Glip-Glop[/b]: Claro! Eu tenho diploma em Engenharia de Silencio.\n[b]Zorbo (ao fundo)[/b]: Isso e um guardanapo com rabiscos!\n[b]Glip-Glop[/b]: Exato. Tecnologia avancada.",
					"choices": [
						{"text": "Ok... obrigado?", "next": "end"},
						{"text": "Voltar.", "next": "start"},
					],
				},
				"gossip": {
					"text": "[b]Glip-Glop[/b]: Dizem que ha um cometa que cheira a sopa.\n[b]Tu[/b]: Sopa?\n[b]Glip-Glop[/b]: Sim. Nao lhe atires, senão vem a colher gigante.",
					"choices": [
						{"text": "Assustador.", "next": "end"},
					],
				},
			}
		"zorbo":
			return {
				"start": {
					"text": "[b]Zorbo[/b]: Oi. Eu sou pegajoso por opcao.\n[b]Tu[/b]: ...\n[b]Zorbo[/b]: Nao julgues. Ja salvei 3 naves so com um abraco.",
					"choices": [
						{"text": "Um abraco salva naves?", "next": "hug"},
						{"text": "Qual e o teu segredo?", "next": "secret"},
						{"text": "Adeus.", "next": "end"},
					],
				},
				"hug": {
					"text": "[b]Zorbo[/b]: A nave parte-se, eu colo. Simples.\n[b]Glip-Glop[/b]: Ele tambem cola recibos ao corpo. Nao recomendo.\n[b]Zorbo[/b]: Sao memorias!",
					"choices": [
						{"text": "Ok, isto e incrivel.", "next": "end"},
					],
				},
				"secret": {
					"text": "[b]Zorbo[/b]: Nunca comas mineral a seco. Mistura com... agua. Ou explode.\n[b]Tu[/b]: Obrigado pela dica, eu acho.",
					"choices": [
						{"text": "Anotado.", "next": "end"},
					],
				},
			}
		"mnem":
			return {
				"start": {
					"text": "[b]Mnem-8[/b]: BIP. Detectei tristeza no teu casco.\n[b]Tu[/b]: Nao e tristeza, e falta de scrap.\n[b]Mnem-8[/b]: Isso e uma forma de tristeza. BIP.",
					"choices": [
						{"text": "Tens uma piada?", "next": "joke"},
						{"text": "Tens uma missao?", "next": "quest"},
						{"text": "Sai.", "next": "end"},
					],
				},
				"joke": {
					"text": "[b]Mnem-8[/b]: Porque e que o cometa cruzou o espaco?\n[b]Tu[/b]: ...\n[b]Mnem-8[/b]: Para esmagar o player. HA. HA. HA.",
					"choices": [
						{"text": "Cruel.", "next": "end"},
					],
				},
				"quest": {
					"text": "[b]Mnem-8[/b]: Missao recomendada: matar inimigos basicos. O universo agradece.\n[b]Tu[/b]: Finalmente alguem sensato.",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
			}
		"krrth":
			return {
				"start": {
					"text": "[b]Krr'th[/b]: Eu negocio apenas em tres coisas: mineral, scrap... e drama.\n[b]Bloop[/b]: Ele cobra taxa de drama.\n[b]Krr'th[/b]: E dedutivel!",
					"choices": [
						{"text": "Quanto custa 1 drama?", "next": "cost"},
						{"text": "Diz-me algo estranho.", "next": "weird"},
						{"text": "Tchau.", "next": "end"},
					],
				},
				"cost": {
					"text": "[b]Krr'th[/b]: Depende. Se chorares, desconto.\n[b]Tu[/b]: Isso e absurdo.\n[b]Krr'th[/b]: Exato. Drama premium.",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
				"weird": {
					"text": "[b]Krr'th[/b]: Ouvi dizer que os snipers escrevem poesia antes de disparar.\n[b]Bloop[/b]: E sempre ha rima com 'dor'.",
					"choices": [
						{"text": "Que fofo/terrivel.", "next": "end"},
					],
				},
			}
		"bloop":
			return {
				"start": {
					"text": "[b]Bloop[/b]: *bloop* *bloop*\n[b]Tu[/b]: Isso foi uma frase?\n[b]Bloop[/b]: Sim. Disse que o teu capacete parece uma panela.",
					"choices": [
						{"text": "Ofensivo.", "next": "offense"},
						{"text": "Obrigado?", "next": "thanks"},
						{"text": "Adeus.", "next": "end"},
					],
				},
				"offense": {
					"text": "[b]Bloop[/b]: Nao e insulto. Panelas guardam coisas valiosas.\n[b]Tu[/b]: Tipo...\n[b]Bloop[/b]: Tipo... pensamentos. E sopa.",
					"choices": [
						{"text": "Ok, aceito.", "next": "end"},
					],
				},
				"thanks": {
					"text": "[b]Bloop[/b]: De nada. Agora vai embora antes que eu elogie mais.",
					"choices": [
						{"text": "Entendido.", "next": "end"},
					],
				},
			}
		"snee":
			return {
				"start": {
					"text": "[b]Snee-Snack[/b]: Acho que o espaco me da alergia.\n[b]Tu[/b]: O espaco?\n[b]Snee-Snack[/b]: Sim. Sempre que vejo estrelas: ATCHIM!\n[b]Krr'th[/b]: Ele espirra e muda o preco do mineral.",
					"choices": [
						{"text": "Saude.", "next": "end"},
					],
				},
			}
		"vexa":
			return {
				"start": {
					"text": "[b]Vexa[/b]: Bem-vindo. Aqui servimos duas coisas: silencio e historias.\n[b]Tu[/b]: E comida?\n[b]Vexa[/b]: As historias alimentam. (mentira, mas funciona.)",
					"choices": [
						{"text": "Conta uma historia.", "next": "story"},
						{"text": "Tenho uma pergunta.", "next": "question"},
						{"text": "Adeus.", "next": "end"},
					],
				},
				"story": {
					"text": "[b]Vexa[/b]: Um dia um tank tentou ser discreto.\n[b]Tu[/b]: E conseguiu?\n[b]Vexa[/b]: Nao. O universo ouviu a armadura a ranger a 3 galaxias.",
					"choices": [
						{"text": "Haha!", "next": "end"},
					],
				},
				"question": {
					"text": "[b]Vexa[/b]: Pergunta.\n[b]Tu[/b]: Porque e que toda a gente fala em sopa?\n[b]Vexa[/b]: Porque a sopa nunca te abandona. Ela encontra-te.",
					"choices": [
						{"text": "Assustador.", "next": "end"},
					],
				},
			}
		"oomu":
			return {
				"start": {
					"text": "[b]Oomu[/b]: Eu nao vendo nada. Eu so observo.\n[b]Rrrl[/b]: Ele observa e depois cobra.\n[b]Oomu[/b]: Detalhes.",
					"choices": [
						{"text": "O que observas?", "next": "observe"},
						{"text": "Adeus.", "next": "end"},
					],
				},
				"observe": {
					"text": "[b]Oomu[/b]: Observo o momento exato em que o player acha que esta seguro.\n[b]Tu[/b]: Isso e sinistro.\n[b]Oomu[/b]: Sim. E preciso.",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
			}
		"rrrl":
			return {
				"start": {
					"text": "[b]Rrrl[/b]: Rrrl.\n[b]Tu[/b]: Isso e um nome ou um aviso?\n[b]Rrrl[/b]: Sim.",
					"choices": [
						{"text": "Justo.", "next": "end"},
					],
				},
			}
		_:
			return {
				"start": {
					"text": "[b]Alien[/b]: Blip-blop. Esta conversa nao foi encontrada.",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
			}

func _on_accept_kill_quest() -> void:
	if _offered_quest_id.is_empty():
		return
	GameState.accept_quest(_offered_quest_id)
	_update_station_quest_buttons()

func _on_claim_station_quest() -> void:
	if _offered_quest_id.is_empty():
		return
	GameState.claim_quest(_offered_quest_id)
	_update_station_quest_buttons()

func _update_station_quest_buttons() -> void:
	accept_kill_quest_button.disabled = true
	claim_station_quest_button.disabled = true
	accept_kill_quest_button.text = "Sem missoes aqui"
	claim_station_quest_button.text = "Entregar missao (recompensa)"

	if _offered_quest_id.is_empty():
		return

	var def: Dictionary = GameState.QUEST_DEFS.get(_offered_quest_id, {}) as Dictionary
	var q: Dictionary = GameState.get_quest_state(_offered_quest_id)
	var accepted := bool(q.get("accepted", false))
	var title := str(def.get("title", "Missao"))

	if not accepted:
		accept_kill_quest_button.text = "Aceitar: %s" % title
		accept_kill_quest_button.disabled = false
		claim_station_quest_button.disabled = true
		return

	var goal: int = int(def.get("goal", 0))
	var progress: int = int(q.get("progress", 0))
	accept_kill_quest_button.text = "%s: %d/%d" % [title, progress, goal]
	accept_kill_quest_button.disabled = true
	claim_station_quest_button.disabled = not GameState.can_claim_quest(_offered_quest_id)

func _on_open_upgrades_pressed() -> void:
	if _active_station == null:
		return
	_set_upgrade_menu_visible(true)

func _apply_trade(give: Dictionary, receive: Dictionary) -> void:
	# trade genérico (1 input -> 1 output)
	if give.size() != 1 or receive.size() != 1:
		return
	var give_type := str(give.keys()[0])
	var receive_type := str(receive.keys()[0])
	GameState.try_exchange(give_type, int(give[give_type]), receive_type, int(receive[receive_type]))

func _rebuild_missions_list() -> void:
	if missions_list == null:
		return

	for child in missions_list.get_children():
		missions_list.remove_child(child)
		child.queue_free()

	var any := false
	for quest_id_variant in GameState.QUEST_DEFS.keys():
		var quest_id := str(quest_id_variant)
		var q: Dictionary = GameState.get_quest_state(quest_id)
		if q.is_empty() or not bool(q.get("accepted", false)):
			continue

		any = true
		var def: Dictionary = GameState.QUEST_DEFS.get(quest_id, {}) as Dictionary
		var goal: int = int(def.get("goal", 0))
		var progress: int = int(q.get("progress", 0))
		var completed := bool(q.get("completed", false))
		var claimed := bool(q.get("claimed", false))
		var reward: Dictionary = def.get("reward", {}) as Dictionary

		var status := "Em progresso"
		if claimed:
			status = "Concluida (recompensa recebida)"
		elif completed:
			status = "Concluida"

		var box := VBoxContainer.new()
		box.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var label := RichTextLabel.new()
		label.bbcode_enabled = true
		label.scroll_active = false
		label.fit_content = false
		label.custom_minimum_size = Vector2(0, 140)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		var deliver := StationCatalog.get_station_titles_offering_quest(quest_id)
		label.text = "[b]%s[/b]\n%s\nProgresso: %d/%d | Estado: %s\nEntrega em: %s\nRecompensa: %s" % [
			str(def.get("title", quest_id)),
			str(def.get("description", "")),
			progress,
			goal,
			status,
			deliver,
			_format_cost(reward)
		]
		box.add_child(label)

		var sep := HSeparator.new()
		missions_list.add_child(box)
		missions_list.add_child(sep)

	if not any:
		var l := Label.new()
		l.text = "Sem missoes ativas. Aceita missoes na Taberna das estacoes."
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		missions_list.add_child(l)

func _rebuild_inventory_list() -> void:
	if inventory_list == null:
		return

	for child in inventory_list.get_children():
		inventory_list.remove_child(child)
		child.queue_free()

	var artifacts_title := Label.new()
	artifacts_title.text = "Artefactos"
	inventory_list.add_child(artifacts_title)

	# Relic (artefacto "principal" antigo)
	var relic := RichTextLabel.new()
	relic.bbcode_enabled = true
	relic.scroll_active = false
	relic.fit_content = false
	relic.custom_minimum_size = Vector2(0, 90)
	relic.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var relic_progress := GameState.artifact_parts_collected
	var relic_goal := GameState.ARTIFACT_PARTS_REQUIRED
	var relic_done := GameState.artifact_completed
	relic.text = "[b]Relic[/b]\nProgresso: %d/%d\nEstado: %s" % [
		relic_progress,
		relic_goal,
		("Completo" if relic_done else "Incompleto"),
	]
	inventory_list.add_child(relic)

	var sep1 := HSeparator.new()
	inventory_list.add_child(sep1)

	# Outros artefactos (gadgets)
	for artifact_id_variant in ArtifactDatabase.ARTIFACTS.keys():
		var artifact_id := str(artifact_id_variant)
		var title := ArtifactDatabase.get_artifact_title(artifact_id)
		var goal := ArtifactDatabase.get_parts_required(artifact_id)
		var progress := GameState.get_artifact_parts(artifact_id)
		var done := GameState.has_artifact(artifact_id)

		var item := RichTextLabel.new()
		item.bbcode_enabled = true
		item.scroll_active = false
		item.fit_content = false
		item.custom_minimum_size = Vector2(0, 110)
		item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

		var gadget_hint := ""
		match artifact_id:
			"vacuum":
				gadget_hint = "Gadget: apanhar pickups automaticamente"
			"reverse_thruster":
				gadget_hint = "Gadget: andar para tras (S)"
			"side_dash":
				gadget_hint = "Gadget: dash lateral (Mouse1/Mouse2)"

		item.text = "[b]%s[/b]\nProgresso: %d/%d\nEstado: %s\n%s" % [
			title,
			progress,
			goal,
			("Desbloqueado" if done else "Bloqueado"),
			gadget_hint,
		]
		inventory_list.add_child(item)

		var sep := HSeparator.new()
		inventory_list.add_child(sep)

	var gadgets_title := Label.new()
	gadgets_title.text = "Gadgets desbloqueados"
	inventory_list.add_child(gadgets_title)

	var any_gadget := false
	if GameState.can_ship_collect_pickups():
		var l1 := Label.new()
		l1.text = "- Aspirador (apanhar pickups)"
		inventory_list.add_child(l1)
		any_gadget = true
	if GameState.has_reverse_thruster():
		var l2 := Label.new()
		l2.text = "- Thruster Reverso (S) x%.2f" % GameState.get_reverse_thrust_factor()
		inventory_list.add_child(l2)
		any_gadget = true

	if not any_gadget:
		var none := Label.new()
		none.text = "Nenhum gadget desbloqueado ainda."
		inventory_list.add_child(none)


func _rebuild_map_zone_list() -> void:
	if map_zone_list == null:
		return

	for child in map_zone_list.get_children():
		map_zone_list.remove_child(child)
		child.queue_free()

	for zone_id in ZoneCatalog.get_zone_ids_sorted_outer_to_core():
		var title := ZoneCatalog.get_zone_title(zone_id)
		var required := ZoneCatalog.get_required_artifact_parts(zone_id)

		var button := Button.new()
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var is_current := (GameState.current_zone_id == zone_id)
		var can_access := GameState.can_access_zone(zone_id)

		if is_current:
			button.text = "%s  [ATUAL]" % title
			button.disabled = true
		elif can_access:
			button.text = "Viajar: %s" % title
			button.disabled = false
		else:
			button.text = "%s  (Bloqueado: %d/%d partes)" % [
				title,
				GameState.artifact_parts_collected,
				required
			]
			button.disabled = true

		if can_access and not is_current:
			button.pressed.connect(_on_zone_selected.bind(zone_id))

		map_zone_list.add_child(button)

func _on_zone_selected(zone_id: String) -> void:
	var manager := get_tree().get_first_node_in_group("zone_manager")
	if manager != null and manager.has_method("switch_to_zone"):
		manager.switch_to_zone(zone_id)
	_set_map_menu_visible(false)
