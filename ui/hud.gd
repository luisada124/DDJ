extends Control

@onready var health_label: Label = $HealthContainer/HealthLabel
@onready var alien_health_label: Label = $AlienHealthContainer/AlienHealthLabel
@onready var scrap_label: Label = $ResourcesContainer/ResourcesBox/ScrapLabel
@onready var mineral_label: Label = $ResourcesContainer/ResourcesBox/MineralLabel
@onready var artifact_label: Label = $ArtifactContainer/ArtifactLabel

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

@onready var npc1_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/NPC1Button
@onready var accept_kill_quest_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/AcceptKillQuestButton

@onready var active_quest_label: RichTextLabel = $TraderMenu/Panel/Margin/VBox/Tabs/Missoes/ActiveQuestLabel
@onready var claim_quest_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Missoes/ClaimQuestButton

@onready var close_trader_button: Button = $TraderMenu/Panel/Margin/VBox/CloseTraderButton

const TRADE_SCRAP_FOR_MINERAL_SCRAP := 10
const TRADE_SCRAP_FOR_MINERAL_MINERAL := 1
const TRADE_MINERAL_FOR_SCRAP_MINERAL := 1
const TRADE_MINERAL_FOR_SCRAP_SCRAP := 8
const ARTIFACT_PART_COST := {"scrap": 80, "mineral": 30}

var _upgrade_buttons: Dictionary
var _active_trader: Node = null
var _menu_guard: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("hud")
	active_quest_label.bbcode_enabled = true

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

	scrap_to_mineral_button.pressed.connect(_on_trade_scrap_to_mineral)
	mineral_to_scrap_button.pressed.connect(_on_trade_mineral_to_scrap)
	buy_artifact_part_button.pressed.connect(_on_buy_artifact_part)
	npc1_button.pressed.connect(_on_npc1_pressed)
	accept_kill_quest_button.pressed.connect(_on_accept_kill_quest)
	claim_quest_button.pressed.connect(_on_claim_kill_quest)

	GameState.state_changed.connect(_update_hud)
	_update_hud()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and _active_trader != null and not trader_menu.visible:
		_set_trader_menu_visible(true)
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("open_upgrades"):
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

func _set_upgrade_menu_visible(visible: bool) -> void:
	if _menu_guard:
		return
	_menu_guard = true
	upgrade_menu.visible = visible
	if visible:
		map_menu.visible = false
		trader_menu.visible = false
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
	_menu_guard = false
	_apply_pause_from_menus()
	_update_hud()

func _apply_pause_from_menus() -> void:
	get_tree().paused = upgrade_menu.visible or map_menu.visible or trader_menu.visible

func _update_hud() -> void:
	var hp: int = GameState.player_health
	var max_hp: int = GameState.player_max_health
	health_label.text = "HP: %d / %d" % [hp, max_hp]

	var alien_hp: int = GameState.alien_health
	var alien_max_hp: int = GameState.alien_max_health
	alien_health_label.text = "Alien: %d / %d" % [alien_hp, alien_max_hp]

	var scrap: int = int(GameState.resources.get("scrap", 0))
	var mineral: int = int(GameState.resources.get("mineral", 0))
	scrap_label.text = "Scrap: %d" % scrap
	mineral_label.text = "Mineral: %d" % mineral

	if GameState.artifact_completed:
		var artifacts := int(GameState.resources.get("artifact", 0))
		artifact_label.text = "Artefacto: OBTIDO (%d)" % artifacts
	else:
		artifact_label.text = "Artefacto: %d / %d" % [GameState.artifact_parts_collected, GameState.ARTIFACT_PARTS_REQUIRED]

	if upgrade_menu.visible:
		_update_upgrade_menu(scrap, mineral)

	if map_menu.visible:
		_rebuild_map_zone_list()

	if trader_menu.visible:
		_update_trader_menu(scrap, mineral)

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

func register_trader_in_range(trader: Node, in_range: bool) -> void:
	if in_range:
		_active_trader = trader
	else:
		if _active_trader == trader:
			_active_trader = null
			if trader_menu.visible:
				_set_trader_menu_visible(false)

func _update_trader_menu(scrap: int, mineral: int) -> void:
	var parts := "%d/%d" % [GameState.artifact_parts_collected, GameState.ARTIFACT_PARTS_REQUIRED]
	trader_info.text = "Scrap: %d | Mineral: %d | Partes: %s" % [scrap, mineral, parts]

	scrap_to_mineral_button.text = "Trocar %d Scrap -> %d Mineral" % [TRADE_SCRAP_FOR_MINERAL_SCRAP, TRADE_SCRAP_FOR_MINERAL_MINERAL]
	mineral_to_scrap_button.text = "Trocar %d Mineral -> %d Scrap" % [TRADE_MINERAL_FOR_SCRAP_MINERAL, TRADE_MINERAL_FOR_SCRAP_SCRAP]
	buy_artifact_part_button.text = "Comprar parte (%s)" % _format_cost(ARTIFACT_PART_COST)

	scrap_to_mineral_button.disabled = int(GameState.resources.get("scrap", 0)) < TRADE_SCRAP_FOR_MINERAL_SCRAP
	mineral_to_scrap_button.disabled = int(GameState.resources.get("mineral", 0)) < TRADE_MINERAL_FOR_SCRAP_MINERAL

	var can_buy_part := (not GameState.artifact_completed) and GameState.can_afford(ARTIFACT_PART_COST)
	buy_artifact_part_button.disabled = not can_buy_part

	_update_missions_ui()

func _on_trade_scrap_to_mineral() -> void:
	GameState.try_exchange("scrap", TRADE_SCRAP_FOR_MINERAL_SCRAP, "mineral", TRADE_SCRAP_FOR_MINERAL_MINERAL)

func _on_trade_mineral_to_scrap() -> void:
	GameState.try_exchange("mineral", TRADE_MINERAL_FOR_SCRAP_MINERAL, "scrap", TRADE_MINERAL_FOR_SCRAP_SCRAP)

func _on_buy_artifact_part() -> void:
	GameState.try_buy_artifact_part(ARTIFACT_PART_COST)

func _on_npc1_pressed() -> void:
	# Placeholder: por agora so existe 1 NPC com 1 missao.
	_update_missions_ui()

func _on_accept_kill_quest() -> void:
	GameState.accept_quest(GameState.QUEST_KILL_15_BASIC)
	_update_missions_ui()

func _on_claim_kill_quest() -> void:
	GameState.claim_quest(GameState.QUEST_KILL_15_BASIC)
	_update_missions_ui()

func _update_missions_ui() -> void:
	var q := GameState.get_quest_state(GameState.QUEST_KILL_15_BASIC)
	if q.is_empty() or not bool(q.get("accepted", false)):
		active_quest_label.text = "Nenhuma missao ativa.\n\nFala com o NPC na Taberna para aceitar uma."
		claim_quest_button.disabled = true
		accept_kill_quest_button.disabled = false
		accept_kill_quest_button.text = "Aceitar missao: Matar 15 inimigos basicos"
		return

	var def := GameState.QUEST_DEFS.get(GameState.QUEST_KILL_15_BASIC, {}) as Dictionary
	var goal: int = int(def.get("goal", 15))
	var progress: int = int(q.get("progress", 0))
	var completed := bool(q.get("completed", false))
	var claimed := bool(q.get("claimed", false))
	var reward := def.get("reward", {}) as Dictionary

	var status := "Em progresso"
	if claimed:
		status = "Concluida (recompensa recebida)"
	elif completed:
		status = "Concluida"

	active_quest_label.text = "[b]%s[/b]\n%s\n\nProgresso: %d / %d\nEstado: %s\nRecompensa: %s" % [
		str(def.get("title", "Missao")),
		str(def.get("description", "")),
		progress,
		goal,
		status,
		_format_cost(reward)
	]

	accept_kill_quest_button.disabled = true
	accept_kill_quest_button.text = "Missao ja aceite"
	claim_quest_button.disabled = not GameState.can_claim_quest(GameState.QUEST_KILL_15_BASIC)

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
