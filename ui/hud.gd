extends Control

@onready var health_label: Label = $HealthContainer/HealthLabel
@onready var scrap_label: Label = $ResourcesContainer/ResourcesBox/ScrapLabel
@onready var mineral_label: Label = $ResourcesContainer/ResourcesBox/MineralLabel
@onready var artifact_label: Label = $ArtifactContainer/ArtifactLabel

@onready var upgrade_menu: Control = $UpgradeMenu
@onready var upgrade_info: Label = $UpgradeMenu/Panel/Margin/VBox/Info
@onready var upgrade_description: Label = $UpgradeMenu/Panel/Margin/VBox/Description

@onready var hull_button: Button = $UpgradeMenu/Panel/Margin/VBox/HullButton
@onready var blaster_button: Button = $UpgradeMenu/Panel/Margin/VBox/BlasterButton
@onready var engine_button: Button = $UpgradeMenu/Panel/Margin/VBox/EngineButton
@onready var thrusters_button: Button = $UpgradeMenu/Panel/Margin/VBox/ThrustersButton
@onready var magnet_button: Button = $UpgradeMenu/Panel/Margin/VBox/MagnetButton

@onready var reset_button: Button = $UpgradeMenu/Panel/Margin/VBox/ResetButton
@onready var close_button: Button = $UpgradeMenu/Panel/Margin/VBox/CloseButton

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

	GameState.state_changed.connect(_update_hud)
	_update_hud()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_upgrades"):
		_set_upgrade_menu_visible(not upgrade_menu.visible)
		get_viewport().set_input_as_handled()
		return

	if upgrade_menu.visible and event.is_action_pressed("ui_cancel"):
		_set_upgrade_menu_visible(false)
		get_viewport().set_input_as_handled()

func _set_upgrade_menu_visible(visible: bool) -> void:
	upgrade_menu.visible = visible
	get_tree().paused = visible
	if visible:
		_on_upgrade_unhovered()
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
		artifact_label.text = "Artefacto: COMPLETO"
	else:
		artifact_label.text = "Artefacto: %d / %d" % [GameState.artifact_parts_collected, GameState.ARTIFACT_PARTS_REQUIRED]

	if upgrade_menu.visible:
		_update_upgrade_menu(scrap, mineral)

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
	upgrade_description.text = "Passa o rato por cima de um upgrade para ver a descri\u00e7\u00e3o."

func _on_reset_pressed() -> void:
	GameState.reset_save()

func _on_close_pressed() -> void:
	_set_upgrade_menu_visible(false)
