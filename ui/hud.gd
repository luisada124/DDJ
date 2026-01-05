extends Control

@onready var health_label: Label = $HealthContainer/HealthLabel
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

var _upgrade_buttons: Dictionary

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

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

	GameState.state_changed.connect(_update_hud)
	_update_hud()

func _unhandled_input(event: InputEvent) -> void:
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

func _set_upgrade_menu_visible(visible: bool) -> void:
	upgrade_menu.visible = visible
	if visible:
		_set_map_menu_visible(false)
	get_tree().paused = visible
	if visible:
		_on_upgrade_unhovered()
	_update_hud()

func _set_map_menu_visible(visible: bool) -> void:
	map_menu.visible = visible
	if visible:
		_set_upgrade_menu_visible(false)
		_rebuild_map_zone_list()
	get_tree().paused = visible
	_update_hud()

func _update_hud() -> void:
	var hp: int = GameState.player_health
	var max_hp: int = GameState.player_max_health
	health_label.text = "HP: %d / %d" % [hp, max_hp]

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
