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
@onready var station_quest_list: VBoxContainer = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/QuestList
@onready var station_quest_details: RichTextLabel = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/QuestDetails
@onready var dialogue_text: RichTextLabel = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/DialogueText
@onready var dialogue_choices: VBoxContainer = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/DialogueChoices
@onready var end_dialogue_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/EndDialogueButton
@onready var open_upgrades_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mecanico/OpenUpgradesButton

@onready var buy_vault_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/BuyVaultButton
@onready var vault_status: RichTextLabel = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultStatus
@onready var deposit_all_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/DepositAllButton
@onready var withdraw_all_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/WithdrawAllButton
@onready var scrap_slider: HSlider = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/ScrapRow/ScrapControls/ScrapSlider
@onready var scrap_percent_label: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/ScrapRow/ScrapControls/ScrapPercent
@onready var deposit_scrap_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/ScrapRow/ScrapControls/DepositScrapButton
@onready var withdraw_scrap_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/ScrapRow/ScrapControls/WithdrawScrapButton

@onready var mineral_slider: HSlider = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/MineralRow/MineralControls/MineralSlider
@onready var mineral_percent_label: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/MineralRow/MineralControls/MineralPercent
@onready var deposit_mineral_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/MineralRow/MineralControls/DepositMineralButton
@onready var withdraw_mineral_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/MineralRow/MineralControls/WithdrawMineralButton

@onready var ametista_slider: HSlider = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/AmetistaRow/AmetistaControls/AmetistaSlider
@onready var ametista_percent_label: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/AmetistaRow/AmetistaControls/AmetistaPercent
@onready var deposit_ametista_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/AmetistaRow/AmetistaControls/DepositAmetistaButton
@onready var withdraw_ametista_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/VaultButtons/AmetistaRow/AmetistaControls/WithdrawAmetistaButton

@onready var close_trader_button: Button = $TraderMenu/Panel/Margin/VBox/CloseTraderButton

@onready var missions_menu: Control = $MissionsMenu
@onready var missions_tabs: TabContainer = $MissionsMenu/Panel/Margin/VBox/Tabs
@onready var missions_list: VBoxContainer = $MissionsMenu/Panel/Margin/VBox/Tabs/Missoes/MissionList
@onready var inventory_list: VBoxContainer = $MissionsMenu/Panel/Margin/VBox/Tabs/Inventario/InventoryScroll/InventoryList
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
	buy_vault_button.pressed.connect(_on_buy_vault_pressed)
	deposit_all_button.pressed.connect(_on_deposit_all_pressed)
	withdraw_all_button.pressed.connect(_on_withdraw_all_pressed)
	scrap_slider.value_changed.connect(_on_vault_percent_changed)
	mineral_slider.value_changed.connect(_on_vault_percent_changed)
	ametista_slider.value_changed.connect(_on_vault_percent_changed)
	deposit_scrap_button.pressed.connect(_on_deposit_percent.bind("scrap"))
	withdraw_scrap_button.pressed.connect(_on_withdraw_percent.bind("scrap"))
	deposit_mineral_button.pressed.connect(_on_deposit_percent.bind("mineral"))
	withdraw_mineral_button.pressed.connect(_on_withdraw_percent.bind("mineral"))
	deposit_ametista_button.pressed.connect(_on_deposit_percent.bind("ametista"))
	withdraw_ametista_button.pressed.connect(_on_withdraw_percent.bind("ametista"))
	end_dialogue_button.pressed.connect(_end_dialogue)

	GameState.state_changed.connect(_update_hud)
	GameState.player_died.connect(_on_player_died)
	GameState.alien_died.connect(_on_alien_died)
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

func _format_quest_rewards(def: Dictionary) -> String:
	var parts: Array[String] = []

	var reward: Dictionary = def.get("reward", {}) as Dictionary
	var res_text := _format_cost(reward)
	if not res_text.is_empty():
		parts.append(res_text)

	var artifact_reward: Dictionary = def.get("artifact_parts_reward", {}) as Dictionary
	for artifact_id_variant in artifact_reward.keys():
		var artifact_id := str(artifact_id_variant)
		var count := int(artifact_reward[artifact_id_variant])
		if count <= 0:
			continue
		parts.append("%s x%d" % [ArtifactDatabase.get_artifact_title(artifact_id), count])

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
	_rebuild_station_quest_list(offered)
	_update_station_quest_buttons()
	_update_npc_button_text()
	_update_vault_ui()

func _update_vault_ui() -> void:
	if vault_status == null:
		return

	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID

	var unlocked := GameState.is_vault_unlocked(station_id)
	var cost: Dictionary = StationCatalog.get_vault_cost(station_id)

	buy_vault_button.visible = not unlocked
	buy_vault_button.disabled = unlocked or not GameState.can_afford(cost)
	buy_vault_button.text = "Comprar cofre (%s)" % _format_cost(cost)

	deposit_all_button.disabled = not unlocked
	withdraw_all_button.disabled = not unlocked
	deposit_scrap_button.disabled = not unlocked
	withdraw_scrap_button.disabled = not unlocked
	deposit_mineral_button.disabled = not unlocked
	withdraw_mineral_button.disabled = not unlocked
	deposit_ametista_button.disabled = not unlocked
	withdraw_ametista_button.disabled = not unlocked

	_on_vault_percent_changed(0.0)

	var carried_scrap := int(GameState.resources.get("scrap", 0))
	var carried_mineral := int(GameState.resources.get("mineral", 0))
	var carried_ametista := int(GameState.resources.get("ametista", 0))

	var vault_scrap := GameState.get_vault_balance(station_id, "scrap")
	var vault_mineral := GameState.get_vault_balance(station_id, "mineral")
	var vault_ametista := GameState.get_vault_balance(station_id, "ametista")

	vault_status.bbcode_enabled = true
	if not unlocked:
		vault_status.text = "Cofre bloqueado nesta estacao.\nCompra para poderes guardar recursos."
		return

	vault_status.text = "[b]Contigo[/b]\nScrap: %d | Mineral: %d | Ametista: %d\n\n[b]No Cofre (%s)[/b]\nScrap: %d | Mineral: %d | Ametista: %d" % [
		carried_scrap,
		carried_mineral,
		carried_ametista,
		StationCatalog.get_station_title(station_id),
		vault_scrap,
		vault_mineral,
		vault_ametista,
	]

func _on_buy_vault_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_vault_cost(station_id)
	GameState.buy_vault(station_id, cost)

func _on_deposit_all_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	GameState.deposit_to_vault(station_id, "scrap", int(GameState.resources.get("scrap", 0)))
	GameState.deposit_to_vault(station_id, "mineral", int(GameState.resources.get("mineral", 0)))
	GameState.deposit_to_vault(station_id, "ametista", int(GameState.resources.get("ametista", 0)))

func _on_withdraw_all_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	GameState.withdraw_from_vault(station_id, "scrap", GameState.get_vault_balance(station_id, "scrap"))
	GameState.withdraw_from_vault(station_id, "mineral", GameState.get_vault_balance(station_id, "mineral"))
	GameState.withdraw_from_vault(station_id, "ametista", GameState.get_vault_balance(station_id, "ametista"))

func _on_vault_percent_changed(_value: float) -> void:
	if scrap_percent_label != null:
		scrap_percent_label.text = "%d%%" % int(scrap_slider.value)
	if mineral_percent_label != null:
		mineral_percent_label.text = "%d%%" % int(mineral_slider.value)
	if ametista_percent_label != null:
		ametista_percent_label.text = "%d%%" % int(ametista_slider.value)

func _get_percent_for_res(res_type: String) -> float:
	match res_type:
		"scrap":
			return float(scrap_slider.value)
		"mineral":
			return float(mineral_slider.value)
		"ametista":
			return float(ametista_slider.value)
	return 100.0

func _on_deposit_percent(res_type: String) -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var pct := _get_percent_for_res(res_type)
	var have := int(GameState.resources.get(res_type, 0))
	var amount := int(floor(have * pct / 100.0))
	if amount <= 0:
		return
	GameState.deposit_to_vault(station_id, res_type, amount)

func _on_withdraw_percent(res_type: String) -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var pct := _get_percent_for_res(res_type)
	var have := GameState.get_vault_balance(station_id, res_type)
	var amount := int(floor(have * pct / 100.0))
	if amount <= 0:
		return
	GameState.withdraw_from_vault(station_id, res_type, amount)

func _on_player_died() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_alien_died() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

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
				{"id": "bandit", "name": "Bandido"},
				{"id": "krrth", "name": "Krr'th"},
				{"id": "snee", "name": "Snee-Snack"},
			]
		"station_epsilon":
			return [
				{"id": "hunter", "name": "Cacador"},
				{"id": "vexa", "name": "Vexa"},
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
	if next_node.begins_with("action:"):
		var parts := next_node.split(":", false)
		if parts.size() >= 3:
			var action := str(parts[1])
			var quest_id := str(parts[2])
			var next_after := "end"
			if parts.size() >= 4:
				next_after = str(parts[3])

			match action:
				"accept_quest":
					GameState.accept_quest(quest_id)
				"claim_quest":
					GameState.claim_quest(quest_id)

			_update_station_quest_buttons()

			if next_after == "end":
				_end_dialogue()
				return

			_dialogue_state["node"] = next_after
			_render_dialogue()
			return

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
		"hunter":
			var hunter_q: Dictionary = GameState.get_quest_state(GameState.QUEST_TAVERN_BANDIT)
			var hunter_accepted := bool(hunter_q.get("accepted", false))
			var hunter_completed := bool(hunter_q.get("completed", false))
			var hunter_claimed := bool(hunter_q.get("claimed", false))

			if not hunter_accepted:
				return {
					"start": {
						"text": "[b]Cacador[/b]: Preciso de ajuda. Um Bandido esta a causar problemas na taberna do Mercador Delta.\n[b]Cacador[/b]: Vai la e derrota-o. Depois volta aqui para receber 3 partes do Thruster Reverso.",
						"choices": [
							{"text": "Aceitar missao.", "next": "action:accept_quest:tavern_bandit:accepted"},
							{"text": "Agora nao.", "next": "end"},
						],
					},
					"accepted": {
						"text": "[b]Cacador[/b]: Boa. Vai ao Mercador Delta e derrota o Bandido.\n[b]Cacador[/b]: A recompensa so e entregue aqui, quando voltares.",
						"choices": [
							{"text": "Ok.", "next": "end"},
						],
					},
				}

			if hunter_accepted and not hunter_completed:
				return {
					"start": {
						"text": "[b]Cacador[/b]: Ainda estas aqui? O Bandido esta no Mercador Delta.\n[b]Cacador[/b]: Derrota-o e volta para receber as partes.",
						"choices": [
							{"text": "Vou ja.", "next": "end"},
						],
					},
				}

			if hunter_completed and not hunter_claimed:
				return {
					"start": {
						"text": "[b]Cacador[/b]: Excelente! Sabia que conseguias.\n[b]Cacador[/b]: Queres receber a recompensa agora?",
						"choices": [
							{"text": "Receber partes.", "next": "action:claim_quest:tavern_bandit:rewarded"},
							{"text": "Depois.", "next": "end"},
						],
					},
					"rewarded": {
						"text": "[b]Cacador[/b]: Aqui estao as 3 partes do Thruster Reverso.",
						"choices": [
							{"text": "Obrigado.", "next": "end"},
						],
					},
				}

			return {
				"start": {
					"text": "[b]Cacador[/b]: Obrigado outra vez. Se precisares de mais trabalho, passa ca mais tarde.",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
			}
		"bandit":
			var bandit_q: Dictionary = GameState.get_quest_state(GameState.QUEST_TAVERN_BANDIT)
			var bandit_accepted := bool(bandit_q.get("accepted", false))
			var bandit_completed := bool(bandit_q.get("completed", false))

			if not bandit_accepted:
				return {
					"start": {
						"text": "[b]Bandido[/b]: O que e que queres? Esta taberna nao e para turistas.",
						"choices": [
							{"text": "Ok.", "next": "end"},
						],
					},
				}

			if bandit_accepted and not bandit_completed:
				return {
					"start": {
						"text": "[b]Bandido[/b]: Hah. Achas que me podes derrotar?\n[b]Bandido[/b]: Entao prova. (Por agora, usa o botao [i]Derrotar Bandido[/i].)",
						"choices": [
							{"text": "Vamos a isso.", "next": "end"},
						],
					},
				}

			return {
				"start": {
					"text": "[b]Bandido[/b]: ...",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
			}
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

	if _offered_quest_id == GameState.QUEST_TAVERN_BANDIT:
		var station_id := _active_station_id
		if station_id.is_empty():
			station_id = DEFAULT_STATION_ID

		var def: Dictionary = GameState.QUEST_DEFS.get(_offered_quest_id, {}) as Dictionary
		var giver_station_id := str(def.get("giver_station_id", ""))
		var target_station_id := str(def.get("target_station_id", ""))

		var q: Dictionary = GameState.get_quest_state(_offered_quest_id)
		var accepted := bool(q.get("accepted", false))
		var completed := bool(q.get("completed", false))

		if station_id == giver_station_id:
			if not accepted:
				GameState.accept_quest(_offered_quest_id)
		elif station_id == target_station_id:
			if accepted and not completed:
				GameState.complete_quest(_offered_quest_id)

		_update_station_quest_buttons()
		return

	GameState.accept_quest(_offered_quest_id)
	_update_station_quest_buttons()

func _on_claim_station_quest() -> void:
	if _offered_quest_id.is_empty():
		return
	if _offered_quest_id == GameState.QUEST_TAVERN_BANDIT:
		return
	GameState.claim_quest(_offered_quest_id)
	_update_station_quest_buttons()

func _update_station_quest_buttons() -> void:
	accept_kill_quest_button.disabled = true
	claim_station_quest_button.disabled = true
	accept_kill_quest_button.text = "Sem missoes aqui"
	claim_station_quest_button.text = "Entregar missao (recompensa)"

	if _offered_quest_id.is_empty():
		if station_quest_details != null:
			station_quest_details.bbcode_enabled = true
			station_quest_details.text = "Seleciona uma missao na lista."
		return

	if _offered_quest_id == GameState.QUEST_TAVERN_BANDIT:
		var station_id := _active_station_id
		if station_id.is_empty():
			station_id = DEFAULT_STATION_ID

		var def: Dictionary = GameState.QUEST_DEFS.get(_offered_quest_id, {}) as Dictionary
		var q: Dictionary = GameState.get_quest_state(_offered_quest_id)
		var accepted := bool(q.get("accepted", false))
		var completed := bool(q.get("completed", false))
		var claimed := bool(q.get("claimed", false))
		var title := str(def.get("title", "Missao"))

		var giver_station_id := str(def.get("giver_station_id", ""))
		var target_station_id := str(def.get("target_station_id", ""))

		claim_station_quest_button.text = "Recompensa: fala com o Cacador"
		claim_station_quest_button.disabled = true

		if station_id == giver_station_id:
			if not accepted:
				accept_kill_quest_button.text = "Aceitar: %s" % title
				accept_kill_quest_button.disabled = false
				_set_station_quest_details(_offered_quest_id)
				return

			if not completed:
				accept_kill_quest_button.text = "%s: vai ao Mercador Delta" % title
				accept_kill_quest_button.disabled = true
				_set_station_quest_details(_offered_quest_id)
				return

			if completed and not claimed:
				accept_kill_quest_button.text = "%s: fala com o Cacador" % title
				accept_kill_quest_button.disabled = true
				_set_station_quest_details(_offered_quest_id)
				return

			accept_kill_quest_button.text = "%s: concluida" % title
			accept_kill_quest_button.disabled = true
			_set_station_quest_details(_offered_quest_id)
			return

		if station_id == target_station_id:
			if not accepted:
				accept_kill_quest_button.text = "%s: fala com o Cacador no Refugio Epsilon" % title
				accept_kill_quest_button.disabled = true
				return

			if accepted and not completed:
				accept_kill_quest_button.text = "Derrotar Bandido (placeholder)"
				accept_kill_quest_button.disabled = false
				_set_station_quest_details(_offered_quest_id)
				return

			accept_kill_quest_button.text = "%s: volta ao Cacador" % title
			accept_kill_quest_button.disabled = true
			_set_station_quest_details(_offered_quest_id)
			return

		return

	var def: Dictionary = GameState.QUEST_DEFS.get(_offered_quest_id, {}) as Dictionary
	var q: Dictionary = GameState.get_quest_state(_offered_quest_id)
	var accepted := bool(q.get("accepted", false))
	var title := str(def.get("title", "Missao"))

	if not accepted:
		accept_kill_quest_button.text = "Aceitar: %s" % title
		accept_kill_quest_button.disabled = false
		claim_station_quest_button.disabled = true
		_set_station_quest_details(_offered_quest_id)
		return

	var goal: int = int(def.get("goal", 0))
	var progress: int = int(q.get("progress", 0))
	accept_kill_quest_button.text = "%s: %d/%d" % [title, progress, goal]
	accept_kill_quest_button.disabled = true
	claim_station_quest_button.disabled = not GameState.can_claim_quest(_offered_quest_id)
	_set_station_quest_details(_offered_quest_id)
	_set_station_quest_details(_offered_quest_id)

func _rebuild_station_quest_list(offered: Array) -> void:
	if station_quest_list == null:
		return

	for child in station_quest_list.get_children():
		station_quest_list.remove_child(child)
		child.queue_free()

	if offered.is_empty():
		var l := Label.new()
		l.text = "Sem missoes nesta taberna."
		station_quest_list.add_child(l)
		return

	var any := false
	for quest_id_variant in offered:
		var quest_id := str(quest_id_variant)
		if not GameState.QUEST_DEFS.has(quest_id):
			continue
		any = true

		var def: Dictionary = GameState.QUEST_DEFS.get(quest_id, {}) as Dictionary
		var title := str(def.get("title", quest_id))
		var q: Dictionary = GameState.get_quest_state(quest_id)
		var accepted := bool(q.get("accepted", false))
		var completed := bool(q.get("completed", false))
		var claimed := bool(q.get("claimed", false))

		var status := ""
		if claimed:
			status = " (entregue)"
		elif completed:
			status = " (pronta)"
		elif accepted:
			status = " (em progresso)"

		var b := Button.new()
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.text = title + status
		b.pressed.connect(_on_select_station_quest.bind(quest_id))
		station_quest_list.add_child(b)

	if not any:
		var l2 := Label.new()
		l2.text = "Sem missoes validas aqui."
		station_quest_list.add_child(l2)

func _on_select_station_quest(quest_id: String) -> void:
	_offered_quest_id = quest_id
	_update_station_quest_buttons()

func _set_station_quest_details(quest_id: String) -> void:
	if station_quest_details == null:
		return
	station_quest_details.bbcode_enabled = true

	var def: Dictionary = GameState.QUEST_DEFS.get(quest_id, {}) as Dictionary
	var q: Dictionary = GameState.get_quest_state(quest_id)
	var goal: int = int(def.get("goal", 0))
	var progress: int = int(q.get("progress", 0))
	var accepted := bool(q.get("accepted", false))
	var completed := bool(q.get("completed", false))
	var claimed := bool(q.get("claimed", false))

	var status := "Disponivel"
	if claimed:
		status = "Entregue"
	elif completed:
		status = "Concluida"
	elif accepted:
		status = "Em progresso"

	var delivery_hint := "Entrega em: %s" % StationCatalog.get_station_titles_offering_quest(quest_id)
	if quest_id == GameState.QUEST_TAVERN_BANDIT:
		delivery_hint = "Entrega: fala com o Cacador (Refugio Epsilon)"

	station_quest_details.text = "[b]%s[/b]\n%s\n\nProgresso: %d/%d\nEstado: %s\n%s\nRecompensa: %s" % [
		str(def.get("title", quest_id)),
		str(def.get("description", "")),
		progress,
		goal,
		status,
		delivery_hint,
		_format_quest_rewards(def),
	]

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
		var delivery_hint := "(entrega numa estacao)"
		if quest_id == GameState.QUEST_TAVERN_BANDIT:
			delivery_hint = "(reclama com o Cacador no Refugio Epsilon)"

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
			_format_quest_rewards(def)
		]
		box.add_child(label)

		if claimed:
			var clear := Button.new()
			clear.text = "Limpar missao"
			clear.pressed.connect(_on_clear_quest.bind(quest_id))
			box.add_child(clear)

		var sep := HSeparator.new()
		missions_list.add_child(box)
		missions_list.add_child(sep)

	if not any:
		var l := Label.new()
		l.text = "Sem missoes ativas. Aceita missoes na Taberna das estacoes."
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		missions_list.add_child(l)

func _on_clear_quest(quest_id: String) -> void:
	GameState.clear_completed_quest(quest_id)

func _rebuild_inventory_list() -> void:
	if inventory_list == null:
		return

	for child in inventory_list.get_children():
		inventory_list.remove_child(child)
		child.queue_free()

	var travel_title := Label.new()
	travel_title.text = "Viagem (Relic)"
	inventory_list.add_child(travel_title)

	# Relic = chave para viajar entre zonas (2/4 desbloqueia Zona 2)
	var relic_progress := GameState.artifact_parts_collected
	var relic_goal := GameState.ARTIFACT_PARTS_REQUIRED
	var req_mid := ZoneCatalog.get_required_artifact_parts("mid")
	var req_core := ZoneCatalog.get_required_artifact_parts("core")

	var relic := RichTextLabel.new()
	relic.bbcode_enabled = true
	relic.scroll_active = false
	relic.fit_content = false
	relic.custom_minimum_size = Vector2(0, 140)
	relic.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var unlocked: Array[String] = []
	if relic_progress >= req_mid:
		unlocked.append("- Zona 2")
	if relic_progress >= req_core:
		unlocked.append("- Centro")

	var unlocked_text := "Nenhuma zona desbloqueada ainda."
	if not unlocked.is_empty():
		unlocked_text = "\n".join(unlocked)

	relic.text = "[b]Relic (chave de viagem)[/b]\nPartes: %d/%d\n\nDesbloqueado:\n%s" % [
		relic_progress,
		relic_goal,
		unlocked_text,
	]
	inventory_list.add_child(relic)

	var sep1 := HSeparator.new()
	inventory_list.add_child(sep1)

	var gadgets_header := Label.new()
	gadgets_header.text = "Gadgets (artefactos)"
	inventory_list.add_child(gadgets_header)

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
