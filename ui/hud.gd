extends Control

@onready var health_label: Label = $HealthContainer/HealthLabel
@onready var alien_health_label: Label = $AlienHealthContainer/AlienHealthLabel
@onready var boss_health_container: Control = $BossHealthContainer
@onready var boss_health_label: Label = $BossHealthContainer/BossHealthBox/BossHealthLabel
@onready var boss_health_bar: ProgressBar = $BossHealthContainer/BossHealthBox/BossHealthBar
@onready var scrap_label: Label = $ResourcesContainer/ResourcesBox/ScrapLabel
@onready var mineral_label: Label = $ResourcesContainer/ResourcesBox/MineralLabel
@onready var ametista_label: Label = $ResourcesContainer/ResourcesBox/AmetistaLabel

@onready var speech_bubble: PanelContainer = $SpeechBubble
@onready var speech_label: Label = $SpeechBubble/SpeechLabel

@onready var upgrade_menu: Control = $UpgradeMenu
@onready var upgrade_info: Label = $UpgradeMenu/Panel/Margin/VBox/Info
@onready var upgrade_description: RichTextLabel = $UpgradeMenu/Panel/Margin/VBox/UpgradeDescription

@onready var hull_button: Button = $UpgradeMenu/Panel/Margin/VBox/MainShipList/HullButton
@onready var blaster_button: Button = $UpgradeMenu/Panel/Margin/VBox/MainShipList/BlasterButton
@onready var laser_damage_button: Button = $UpgradeMenu/Panel/Margin/VBox/MainShipList/LaserDamageButton
@onready var laser_speed_button: Button = $UpgradeMenu/Panel/Margin/VBox/MainShipList/LaserSpeedButton
@onready var engine_button: Button = $UpgradeMenu/Panel/Margin/VBox/MainShipList/EngineButton
@onready var thrusters_button: Button = $UpgradeMenu/Panel/Margin/VBox/MainShipList/ThrustersButton
@onready var magnet_button: Button = $UpgradeMenu/Panel/Margin/VBox/MainShipList/MagnetButton
@onready var aux_ship_locked_info: Label = $UpgradeMenu/Panel/Margin/VBox/AuxShipLockedInfo
@onready var aux_ship_list: VBoxContainer = $UpgradeMenu/Panel/Margin/VBox/AuxShipList
@onready var aux_fire_rate_button: Button = $UpgradeMenu/Panel/Margin/VBox/AuxShipList/AuxFireRateButton
@onready var aux_damage_button: Button = $UpgradeMenu/Panel/Margin/VBox/AuxShipList/AuxDamageButton
@onready var aux_range_button: Button = $UpgradeMenu/Panel/Margin/VBox/AuxShipList/AuxRangeButton
@onready var aux_laser_speed_button: Button = $UpgradeMenu/Panel/Margin/VBox/AuxShipList/AuxLaserSpeedButton

@onready var reset_button: Button = $UpgradeMenu/Panel/Margin/VBox/ResetButton
@onready var close_button: Button = $UpgradeMenu/Panel/Margin/VBox/CloseButton

@onready var map_menu: Control = $MapMenu
@onready var map_zone_list: VBoxContainer = $MapMenu/Panel/Margin/VBox/Tabs/Zonas/ZoneList
@onready var map_info_label: Label = $MapMenu/Panel/Margin/VBox/Info
@onready var close_map_button: Button = $MapMenu/Panel/Margin/VBox/CloseMapButton

@onready var trader_menu: Control = $TraderMenu
@onready var boss_planet_panel: VBoxContainer = $TraderMenu/Panel/Margin/VBox/BossPlanetPanel
@onready var boss_planet_info: Label = $TraderMenu/Panel/Margin/VBox/BossPlanetPanel/BossPlanetInfo
@onready var boss_planet_collect_button: Button = $TraderMenu/Panel/Margin/VBox/BossPlanetPanel/BossPlanetCollectButton
@onready var trader_info: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/Info
@onready var scrap_to_mineral_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/ScrapToMineralButton
@onready var mineral_to_scrap_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/MineralToScrapButton
@onready var buy_artifact_part_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyArtifactPartButton
@onready var buy_vacuum_map_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyVacuumMapButton
@onready var buy_alpha_station_map_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyAlphaStationMapButton
@onready var buy_vacuum_part_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyVacuumPartButton
@onready var buy_reverse_thruster_part_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyReverseThrusterPartButton
@onready var buy_reverse_thruster_map_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyReverseThrusterMapButton
@onready var buy_side_dash_part_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuySideDashPartButton
@onready var buy_auto_regen_map_zone1_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyAutoRegenMapZone1Button
@onready var buy_auto_regen_map_zone2_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyAutoRegenMapZone2Button
@onready var buy_kappa_station_map_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyKappaStationMapButton
@onready var buy_beta_station_map_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyBetaStationMapButton
@onready var buy_aux_ship_part_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyAuxShipPartButton
@onready var buy_repair_kit_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/BuyRepairKitButton
@onready var ametista_to_mineral_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/AmetistaToMineralButton
@onready var ametista_to_scrap_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mercado/AmetistaToScrapButton
@onready var trader_tabs: TabContainer = $TraderMenu/Panel/Margin/VBox/Tabs
@onready var tavern_bottom_bar: Control = $TraderMenu/Panel/Margin/VBox/TavernBottomBar

@onready var npc1_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/NPC1Button
@onready var npc2_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/NPC2Button
@onready var npc3_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/NPC3Button
@onready var accept_kill_quest_button: Button = $TraderMenu/Panel/Margin/VBox/TavernBottomBar/AcceptKillQuestButton
@onready var claim_station_quest_button: Button = $TraderMenu/Panel/Margin/VBox/TavernBottomBar/ClaimStationQuestButton
@onready var station_quest_list: VBoxContainer = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/QuestList
@onready var station_quest_details: RichTextLabel = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/QuestDetails
@onready var delivery_list: VBoxContainer = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/DeliveryList
@onready var dialogue_text: RichTextLabel = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/DialogueText
@onready var dialogue_choices: VBoxContainer = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/DialogueChoices
@onready var end_dialogue_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/EndDialogueButton
@onready var bandit_qte_separator: HSeparator = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/BanditQteSeparator
@onready var bandit_qte_panel: VBoxContainer = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/BanditQtePanel
@onready var bandit_qte_info: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/BanditQtePanel/BanditQteInfo
@onready var bandit_qte_progress: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/BanditQtePanel/BanditQteProgress
@onready var bandit_qte_prompt: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/BanditQtePanel/BanditQtePrompt
@onready var bandit_qte_start_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/BanditQtePanel/BanditQteStartButton
@onready var bandit_qte_result: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/BanditQtePanel/BanditQteResult
@onready var knife_game_high_score: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/KnifeGameHighScore
@onready var knife_game_score: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/KnifeGameScore
@onready var knife_game_prompt: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/KnifeGamePrompt
@onready var knife_game_result: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/KnifeGameResult
@onready var knife_game_start_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/KnifeGameStartButton
@onready var debug_boss_separator: HSeparator = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/DebugBossSeparator
@onready var debug_boss_planet_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Taberna/TabernaScroll/TabernaContent/DebugBossPlanetButton
@onready var open_upgrades_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mecanico/OpenUpgradesButton
@onready var repair_ship_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Mecanico/RepairShipButton

@onready var buy_vault_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/BuyVaultButton
@onready var vault_status: RichTextLabel = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultStatus
@onready var deposit_all_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/DepositAllButton
@onready var withdraw_all_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/WithdrawAllButton
@onready var scrap_slider: HSlider = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/ScrapRow/ScrapControls/ScrapSlider
@onready var scrap_percent_label: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/ScrapRow/ScrapControls/ScrapPercent
@onready var deposit_scrap_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/ScrapRow/ScrapControls/DepositScrapButton
@onready var withdraw_scrap_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/ScrapRow/ScrapControls/WithdrawScrapButton

@onready var mineral_slider: HSlider = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/MineralRow/MineralControls/MineralSlider
@onready var mineral_percent_label: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/MineralRow/MineralControls/MineralPercent
@onready var deposit_mineral_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/MineralRow/MineralControls/DepositMineralButton
@onready var withdraw_mineral_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/MineralRow/MineralControls/WithdrawMineralButton

@onready var ametista_slider: HSlider = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/AmetistaRow/AmetistaControls/AmetistaSlider
@onready var ametista_percent_label: Label = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/AmetistaRow/AmetistaControls/AmetistaPercent
@onready var deposit_ametista_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/AmetistaRow/AmetistaControls/DepositAmetistaButton
@onready var withdraw_ametista_button: Button = $TraderMenu/Panel/Margin/VBox/Tabs/Cofre/CofreScroll/CofreContent/VaultButtons/AmetistaRow/AmetistaControls/WithdrawAmetistaButton

@onready var close_trader_button: Button = $TraderMenu/Panel/Margin/VBox/CloseTraderButton

@onready var missions_menu: Control = $MissionsMenu
@onready var missions_tabs: TabContainer = $MissionsMenu/Panel/Margin/VBox/Tabs
@onready var missions_list: VBoxContainer = $MissionsMenu/Panel/Margin/VBox/Tabs/Missoes/MissionScroll/MissionList
@onready var inventory_list: VBoxContainer = $MissionsMenu/Panel/Margin/VBox/Tabs/Inventario/InventoryScroll/InventoryList
@onready var debug_give_resources_button: Button = $MissionsMenu/Panel/Margin/VBox/DebugGiveResourcesButton
@onready var debug_unlock_all_gadgets_button: Button = $MissionsMenu/Panel/Margin/VBox/DebugUnlockAllGadgetsButton
@onready var close_missions_button: Button = $MissionsMenu/Panel/Margin/VBox/CloseMissionsButton
@onready var reset_save_tab_button: Button = $MissionsMenu/Panel/Margin/VBox/ResetSaveTabButton

const DEFAULT_STATION_ID := "station_alpha"
const BOSS_PLANET_STATION_ID := "boss_planet"
const QuestDatabase := preload("res://systems/QuestDatabase.gd")
const BOSS_ARROW_TEXTURE := preload("res://textures/seta.png")
const BOSS_ARROW_RADIUS := 120.0
const BOSS_PLANET_FALLBACK_POS := Vector2(-3172, -3172)
const BANDIT_QTE_KEYS := [KEY_W, KEY_A, KEY_S, KEY_D]
const KNIFE_GAME_SEQUENCE := [KEY_A, KEY_S, KEY_D, KEY_W]
const KNIFE_GAME_ATTEMPT_TIME := 20.0

var _upgrade_buttons: Dictionary
var _active_trader: Node = null
var _active_station: Node = null
var _active_station_id: String = ""
var _offered_quest_id: String = ""
var _dialogue_state: Dictionary = {}
var _station_npcs: Array = []
var _active_npc_id: String = ""
var _active_npc_type: String = ""
var _bandit_qte_active: bool = false
var _bandit_qte_sequence: Array[int] = []
var _bandit_qte_index: int = 0
var _bandit_qte_time_left: float = 0.0
var _bandit_qte_time_per_step: float = 0.0
var _bandit_qte_steps: int = 0
var _bandit_qte_quest_id: String = ""
var _bandit_qte_last_failed: bool = false
var _boss_arrow: Sprite2D = null
var _boss_node: Node = null
var _knife_game_active: bool = false
var _knife_game_score: int = 0
var _knife_game_sequence_index: int = 0
var _knife_game_time_left: float = 0.0
var _speech_time_left: float = 0.0
var _speech_queue: Array[Dictionary] = []
var _speech_has_anchor: bool = false
var _speech_anchor_world: Vector2 = Vector2.ZERO
var _menu_guard: bool = false
var _fullscreen_toggle_blocked: bool = false
var _fullscreen_toggle_warned: bool = false

const TRADER_TAB_TAVERN := 1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("hud")

	_upgrade_buttons = {
		"hull": hull_button,
		"blaster": blaster_button,
		"laser_damage": laser_damage_button,
		"laser_speed": laser_speed_button,
		"engine": engine_button,
		"thrusters": thrusters_button,
		"magnet": magnet_button,
		"aux_fire_rate": aux_fire_rate_button,
		"aux_damage": aux_damage_button,
		"aux_range": aux_range_button,
		"aux_laser_speed": aux_laser_speed_button,
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
	if reset_save_tab_button != null:
		reset_save_tab_button.pressed.connect(_on_reset_pressed)
	if debug_give_resources_button != null:
		debug_give_resources_button.visible = OS.is_debug_build()
		debug_give_resources_button.pressed.connect(_on_debug_give_resources_pressed)
	if debug_boss_separator != null:
		debug_boss_separator.visible = OS.is_debug_build()
	if debug_boss_planet_button != null:
		debug_boss_planet_button.visible = OS.is_debug_build()
		debug_boss_planet_button.pressed.connect(_on_debug_boss_planet_pressed)
	if debug_unlock_all_gadgets_button != null:
		debug_unlock_all_gadgets_button.visible = OS.is_debug_build()
		debug_unlock_all_gadgets_button.pressed.connect(_on_debug_unlock_all_gadgets_pressed)

	scrap_to_mineral_button.pressed.connect(_on_trade_scrap_to_mineral)
	mineral_to_scrap_button.pressed.connect(_on_trade_mineral_to_scrap)
	buy_artifact_part_button.pressed.connect(_on_buy_artifact_part)
	buy_vacuum_map_button.pressed.connect(_on_buy_vacuum_map_pressed)
	buy_alpha_station_map_button.pressed.connect(_on_buy_alpha_station_map_pressed)
	buy_vacuum_part_button.pressed.connect(_on_buy_vacuum_part_pressed)
	buy_reverse_thruster_part_button.pressed.connect(_on_buy_reverse_thruster_part_pressed)
	buy_reverse_thruster_map_button.pressed.connect(_on_buy_reverse_thruster_map_pressed)
	buy_side_dash_part_button.pressed.connect(_on_buy_side_dash_part_pressed)
	buy_auto_regen_map_zone1_button.pressed.connect(_on_buy_auto_regen_map_zone1_pressed)
	buy_auto_regen_map_zone2_button.pressed.connect(_on_buy_auto_regen_map_zone2_pressed)
	buy_kappa_station_map_button.pressed.connect(_on_buy_kappa_station_map_pressed)
	buy_beta_station_map_button.pressed.connect(_on_buy_beta_station_map_pressed)
	buy_aux_ship_part_button.pressed.connect(_on_buy_aux_ship_part_pressed)
	buy_repair_kit_button.pressed.connect(_on_buy_repair_kit_pressed)
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
	knife_game_start_button.pressed.connect(_on_knife_game_start_pressed)
	repair_ship_button.pressed.connect(_on_repair_ship_pressed)
	if boss_planet_collect_button != null:
		boss_planet_collect_button.pressed.connect(_on_boss_planet_collect_pressed)
	if trader_tabs != null:
		trader_tabs.tab_changed.connect(_on_trader_tab_changed)
		_on_trader_tab_changed(trader_tabs.current_tab)
	if bandit_qte_start_button != null:
		bandit_qte_start_button.pressed.connect(_on_bandit_qte_start_pressed)

	GameState.state_changed.connect(_update_hud)
	GameState.player_died.connect(_on_player_died)
	GameState.alien_died.connect(_on_alien_died)
	GameState.speech_requested.connect(_show_speech_bubble)
	GameState.speech_requested_at.connect(_show_speech_bubble_at)
	GameState.speech_requested_timed.connect(_show_speech_bubble_timed)
	_update_hud()
	_update_boss_compass()

func _process(delta: float) -> void:
	if _bandit_qte_active:
		_bandit_qte_time_left -= delta
		if _bandit_qte_time_left <= 0.0:
			_finish_bandit_qte(false, "Tempo esgotado.")
		else:
			_update_bandit_qte_prompt_text()

	elif _knife_game_active:
		_knife_game_time_left -= delta
		if _knife_game_time_left <= 0.0:
			_finish_knife_game("Tempo acabou.")
		else:
			_update_knife_game_prompt_text()

	_update_boss_compass()
	_update_boss_health_ui()
	_update_speech_bubble(delta)

func _update_speech_bubble(delta: float) -> void:
	if speech_bubble == null:
		return
	if not speech_bubble.visible:
		return

	_speech_time_left -= delta
	if _speech_time_left <= 0.0:
		if _speech_queue.size() > 0:
			var next_item: Dictionary = _speech_queue[0] as Dictionary
			_speech_queue.remove_at(0)
			_start_speech(
				str(next_item.get("text", "")),
				bool(next_item.get("has_anchor", false)),
				next_item.get("world_pos", Vector2.ZERO) as Vector2,
				float(next_item.get("duration", 4.5))
			)
		else:
			speech_bubble.visible = false
			return

	var world_pos := Vector2.ZERO
	if _speech_has_anchor:
		world_pos = _speech_anchor_world
	else:
		var p := get_tree().get_first_node_in_group("player")
		if p is Node2D:
			world_pos = (p as Node2D).global_position
		else:
			return

	if true:
		var cam: Camera2D = get_viewport().get_camera_2d()
		var screen_pos := world_pos
		if cam != null:
			var center: Vector2 = cam.global_position
			if cam.has_method("get_screen_center_position"):
				center = cam.get_screen_center_position()
			var vp_size: Vector2 = get_viewport().get_visible_rect().size
			var zoom: Vector2 = cam.zoom
			screen_pos = (world_pos - center) * zoom + vp_size * 0.5
		speech_bubble.position = screen_pos + Vector2(20, -90)

func _show_speech_bubble(text: String) -> void:
	if speech_bubble == null or speech_label == null:
		return
	if speech_bubble.visible and _speech_time_left > 0.0:
		_speech_queue.append({
			"text": text,
			"has_anchor": false,
			"world_pos": Vector2.ZERO,
			"duration": 4.5,
		})
		return
	_start_speech(text, false, Vector2.ZERO, 4.5)

func _show_speech_bubble_at(text: String, world_pos: Vector2) -> void:
	if speech_bubble == null or speech_label == null:
		return
	if speech_bubble.visible and _speech_time_left > 0.0:
		_speech_queue.append({
			"text": text,
			"has_anchor": true,
			"world_pos": world_pos,
			"duration": 4.5,
		})
		return
	_start_speech(text, true, world_pos, 4.5)

func _show_speech_bubble_timed(text: String, duration: float) -> void:
	if speech_bubble == null or speech_label == null:
		return
	var d: float = maxf(0.1, duration)
	if speech_bubble.visible and _speech_time_left > 0.0:
		_speech_queue.append({
			"text": text,
			"has_anchor": false,
			"world_pos": Vector2.ZERO,
			"duration": d,
		})
		return
	_start_speech(text, false, Vector2.ZERO, d)

func _start_speech(text: String, has_anchor: bool, world_pos: Vector2, duration: float) -> void:
	speech_label.text = text
	_speech_has_anchor = has_anchor
	_speech_anchor_world = world_pos
	_speech_time_left = maxf(0.1, duration)
	speech_bubble.visible = true


func _input(event: InputEvent) -> void:
	if _bandit_qte_active and trader_menu.visible and event is InputEventKey and (event as InputEventKey).pressed and not (event as InputEventKey).echo:
		var key_event := event as InputEventKey
		if _handle_bandit_qte_input(key_event):
			get_viewport().set_input_as_handled()
			return

	if _knife_game_active and trader_menu.visible and event is InputEventKey and (event as InputEventKey).pressed and not (event as InputEventKey).echo:
		var key_event := event as InputEventKey
		if _handle_knife_game_input(key_event):
			get_viewport().set_input_as_handled()
			return

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
	# Fullscreen toggle (F11 ou Alt+Enter)
	if event is InputEventKey and (event as InputEventKey).pressed and not (event as InputEventKey).echo:
		var key_event_fs := event as InputEventKey
		if key_event_fs.keycode == KEY_F11 or (key_event_fs.keycode == KEY_ENTER and key_event_fs.alt_pressed):
			if _fullscreen_toggle_blocked:
				get_viewport().set_input_as_handled()
				return

			var mode := DisplayServer.window_get_mode()
			if mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				call_deferred("_verify_fullscreen_toggle")
			get_viewport().set_input_as_handled()
			return

	if event.is_action_pressed("interact") and _active_trader != null and not trader_menu.visible:
		# Descobrir a estação automaticamente na primeira interação
		if not _active_station_id.is_empty() and not GameState.is_station_discovered(_active_station_id):
			GameState.discover_station(_active_station_id)
		_set_trader_menu_visible(true)
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("open_upgrades"):
		if _active_station != null:
			# Descobrir a estação automaticamente na primeira interação
			if not _active_station_id.is_empty() and not GameState.is_station_discovered(_active_station_id):
				GameState.discover_station(_active_station_id)
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

func _verify_fullscreen_toggle() -> void:
	# No "embedded game" do editor, Godot não permite fullscreen (imprime: Embedded window only supports Windowed mode.)
	var mode := DisplayServer.window_get_mode()
	var is_fullscreen := mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	if is_fullscreen:
		return

	# Bloqueia novas tentativas para não spammar a consola.
	_fullscreen_toggle_blocked = true
	if not _fullscreen_toggle_warned:
		_fullscreen_toggle_warned = true
		push_warning("Fullscreen não é suportado quando o jogo está a correr em modo Embedded no editor. Desliga 'Embed Game' e corre numa janela separada para testar fullscreen.")

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
	if not visible:
		_stop_bandit_qte()
		_stop_knife_game()
	if visible:
		_end_dialogue()
		if trader_tabs != null:
			_on_trader_tab_changed(trader_tabs.current_tab)
		_update_boss_planet_ui()

func _on_trader_tab_changed(_tab: int) -> void:
	if tavern_bottom_bar == null or trader_tabs == null:
		return
	tavern_bottom_bar.visible = false

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
	upgrade_info.text = "Scrap: %d | Mineral: %d" % [scrap, mineral]

	var aux_unlocked := GameState.has_aux_ship()
	if aux_ship_list != null:
		aux_ship_list.visible = aux_unlocked
	if aux_ship_locked_info != null:
		aux_ship_locked_info.visible = not aux_unlocked

	for upgrade_id in _upgrade_buttons.keys():
		var button: Button = _upgrade_buttons[upgrade_id]

		var title := GameState.get_upgrade_title(upgrade_id)
		var level := GameState.get_upgrade_level(upgrade_id)
		var max_level := GameState.get_upgrade_max_level(upgrade_id)
		var is_aux: bool = str(upgrade_id).begins_with("aux_")

		var button_color := Color(1, 1, 1)
		if is_aux and not aux_unlocked:
			button.text = "%s (Bloqueado)" % title
			button.disabled = true
			button.modulate = Color(0.6, 0.6, 0.6)
			continue
		if level >= 5:
			button_color = Color(0.0, 1.0, 0.0)
		button.modulate = button_color

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
	if def.is_empty():
		return "Nenhuma"
	
	var parts: Array[String] = []

	var reward: Dictionary = def.get("reward", {}) as Dictionary
	if not reward.is_empty():
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

	var consumable_reward: Dictionary = def.get("consumable_reward", {}) as Dictionary
	for consumable_type_variant in consumable_reward.keys():
		var consumable_type := str(consumable_type_variant)
		var count := int(consumable_reward[consumable_type_variant])
		if count <= 0:
			continue
		var consumable_name := consumable_type
		match consumable_type:
			"repair_kit":
				consumable_name = "Kit de Reparação"
		parts.append("%s x%d" % [consumable_name, count])

	var map_reward := str(def.get("map_reward", ""))
	if not map_reward.is_empty():
		var map_name := map_reward
		match map_reward:
			"side_dash":
				map_name = "Mapa Side Dash"
			"aux_ship":
				map_name = "Mapa Aux Ship"
			"random_station":
				map_name = "Mapa de Estação"
		parts.append(map_name)

	var discover_station_reward := str(def.get("discover_station_reward", ""))
	if not discover_station_reward.is_empty():
		var station_title := StationCatalog.get_station_title(discover_station_reward)
		parts.append("Descobre: %s" % station_title)

	if parts.is_empty():
		return "Nenhuma"
	
	return " | ".join(parts)

func _on_upgrade_pressed(upgrade_id: String) -> void:
	if upgrade_id.begins_with("aux_") and not GameState.has_aux_ship():
		return
	GameState.buy_upgrade(upgrade_id)

func _on_upgrade_hovered(upgrade_id: String) -> void:
	if upgrade_id.begins_with("aux_") and not GameState.has_aux_ship():
		upgrade_description.text = "Desbloqueia a Nave Auxiliar para usar estes upgrades."
		return
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
		if _active_station_id != station_id:
			_active_npc_id = ""
			_active_npc_type = ""
		_active_station = station
		_active_station_id = station_id
	else:
		if _active_station == station:
			_active_station = null
			_active_station_id = ""
			_active_npc_id = ""
			_active_npc_type = ""
			_stop_bandit_qte()
			_stop_knife_game()
			if upgrade_menu.visible:
				_set_upgrade_menu_visible(false)
			if trader_menu.visible:
				_set_trader_menu_visible(false)

func _update_trader_menu(scrap: int, mineral: int) -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var is_boss_planet := station_id == BOSS_PLANET_STATION_ID
	_update_boss_planet_ui()
	if is_boss_planet:
		return

	var trades: Dictionary = StationCatalog.get_trades(station_id)
	var artifact_cost: Dictionary = StationCatalog.get_artifact_part_cost(station_id)
	var vacuum_map_cost: Dictionary = StationCatalog.get_vacuum_map_cost(station_id)
	var alpha_station_map_cost: Dictionary = StationCatalog.get_station_alpha_map_cost(station_id)
	var vacuum_part_cost: Dictionary = StationCatalog.get_vacuum_part_shop_cost(station_id)
	var rt_shop_cost: Dictionary = StationCatalog.get_reverse_thruster_shop_part_cost(station_id)
	var rt_map_cost: Dictionary = StationCatalog.get_reverse_thruster_map_cost(station_id)
	var sd_shop_cost: Dictionary = StationCatalog.get_side_dash_shop_part_cost(station_id)
	var ar_map1_cost: Dictionary = StationCatalog.get_auto_regen_map_zone1_cost(station_id)
	var ar_map2_cost: Dictionary = StationCatalog.get_auto_regen_map_zone2_cost(station_id)
	var kappa_map_cost: Dictionary = StationCatalog.get_kappa_station_map_cost(station_id)
	var beta_map_cost: Dictionary = StationCatalog.get_beta_station_map_cost(station_id)
	var aux_shop_cost: Dictionary = StationCatalog.get_aux_ship_shop_part_cost(station_id)

	var parts := "%d/%d" % [GameState.artifact_parts_collected, GameState.ARTIFACT_PARTS_REQUIRED]
	trader_info.text = "%s\nScrap: %d | Mineral: %d | Partes: %s" % [
		StationCatalog.get_station_title(station_id),
		scrap,
		mineral,
		parts
	]
	if not vacuum_map_cost.is_empty():
		if GameState.vacuum_map_bought:
			trader_info.text += "\nMapa Vacuum: comprado (minimapa marcado)"
		elif GameState.has_artifact("vacuum") or GameState.vacuum_random_part_collected:
			trader_info.text += "\nMapa Vacuum: indisponivel"
		else:
			trader_info.text += "\nMapa Vacuum: %s" % _format_cost(vacuum_map_cost)

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
	var show_artifact_part := not artifact_cost.is_empty()
	buy_artifact_part_button.visible = show_artifact_part
	if show_artifact_part:
		buy_artifact_part_button.text = "Comprar parte (%s)" % _format_cost(artifact_cost)
	var show_vacuum_map := not vacuum_map_cost.is_empty() and not GameState.vacuum_map_bought and not GameState.has_artifact("vacuum") and not GameState.vacuum_random_part_collected
	buy_vacuum_map_button.visible = show_vacuum_map
	if show_vacuum_map:
		buy_vacuum_map_button.text = "Mapa para vacuum (marca no minimapa) (%s)" % _format_cost(vacuum_map_cost)
		buy_vacuum_map_button.disabled = not GameState.can_afford(vacuum_map_cost)

	var show_alpha_station_map := not alpha_station_map_cost.is_empty() and not GameState.alpha_station_map_bought and not GameState.is_station_discovered("station_alpha")
	buy_alpha_station_map_button.visible = show_alpha_station_map
	if show_alpha_station_map:
		buy_alpha_station_map_button.text = "Mapa para Estacao Alfa (marca no minimapa) (%s)" % _format_cost(alpha_station_map_cost)
		buy_alpha_station_map_button.disabled = not GameState.can_afford(alpha_station_map_cost)

	var vacuum_parts_have := GameState.get_artifact_parts("vacuum")
	var vacuum_parts_required := ArtifactDatabase.get_parts_required("vacuum")
	var show_vacuum_part := not vacuum_part_cost.is_empty() and not GameState.vacuum_shop_part_bought and not GameState.has_artifact("vacuum") and vacuum_parts_have < vacuum_parts_required
	buy_vacuum_part_button.visible = show_vacuum_part
	if show_vacuum_part:
		buy_vacuum_part_button.text = "Comprar 1 peca Vacuum (%s)" % _format_cost(vacuum_part_cost)
		buy_vacuum_part_button.disabled = not GameState.can_afford(vacuum_part_cost)

	var rt_parts_have := GameState.get_artifact_parts("reverse_thruster")
	var rt_parts_required := ArtifactDatabase.get_parts_required("reverse_thruster")
	var rt_station_already_bought := bool(GameState.reverse_thruster_shop_parts_bought.get(station_id, false))
	var show_rt_part := not rt_shop_cost.is_empty() and not GameState.has_artifact("reverse_thruster") and rt_parts_have < rt_parts_required and not rt_station_already_bought
	buy_reverse_thruster_part_button.visible = show_rt_part
	if show_rt_part:
		buy_reverse_thruster_part_button.text = "Comprar 1 peca Reverse Thruster (%s)" % _format_cost(rt_shop_cost)
		buy_reverse_thruster_part_button.disabled = not GameState.can_afford(rt_shop_cost)

	var show_rt_map := not rt_map_cost.is_empty() and not GameState.reverse_thruster_map_bought and not GameState.has_artifact("reverse_thruster") and not GameState.reverse_thruster_random_part_collected
	buy_reverse_thruster_map_button.visible = show_rt_map
	if show_rt_map:
		buy_reverse_thruster_map_button.text = "Mapa Reverse Thruster (marca no minimapa) (%s)" % _format_cost(rt_map_cost)
		buy_reverse_thruster_map_button.disabled = not GameState.can_afford(rt_map_cost)

	var sd_parts_have := GameState.get_artifact_parts("side_dash")
	var sd_parts_required := ArtifactDatabase.get_parts_required("side_dash")
	var sd_station_already_bought := bool(GameState.side_dash_shop_parts_bought.get(station_id, false))
	var show_sd_part := GameState.current_zone_id == "mid" and not sd_shop_cost.is_empty() and not GameState.has_artifact("side_dash") and sd_parts_have < sd_parts_required and not sd_station_already_bought
	buy_side_dash_part_button.visible = show_sd_part
	if show_sd_part:
		buy_side_dash_part_button.text = "Comprar 1 peca Side Dash (%s)" % _format_cost(sd_shop_cost)
		buy_side_dash_part_button.disabled = not GameState.can_afford(sd_shop_cost)

	var show_ar_map1 := not ar_map1_cost.is_empty() and not GameState.auto_regen_map_zone1_bought and not GameState.has_artifact("auto_regen") and not GameState.auto_regen_part1_collected
	buy_auto_regen_map_zone1_button.visible = show_ar_map1
	if show_ar_map1:
		buy_auto_regen_map_zone1_button.text = "Mapa Auto Regen (peca 1) (%s)" % _format_cost(ar_map1_cost)
		buy_auto_regen_map_zone1_button.disabled = not GameState.can_afford(ar_map1_cost)

	var show_ar_map2 := GameState.current_zone_id == "mid" and not ar_map2_cost.is_empty() and not GameState.auto_regen_map_zone2_bought and not GameState.has_artifact("auto_regen") and not GameState.auto_regen_part2_collected
	buy_auto_regen_map_zone2_button.visible = show_ar_map2
	if show_ar_map2:
		buy_auto_regen_map_zone2_button.text = "Mapa Auto Regen (peca 2) (%s)" % _format_cost(ar_map2_cost)
		buy_auto_regen_map_zone2_button.disabled = not GameState.can_afford(ar_map2_cost)

	var show_kappa_map := not kappa_map_cost.is_empty() and not GameState.kappa_station_map_bought and not GameState.is_station_discovered("station_kappa")
	buy_kappa_station_map_button.visible = show_kappa_map
	if show_kappa_map:
		buy_kappa_station_map_button.text = "Mapa para Posto Kappa (marca no minimapa) (%s)" % _format_cost(kappa_map_cost)
		buy_kappa_station_map_button.disabled = not GameState.can_afford(kappa_map_cost)

	var show_beta_map := not beta_map_cost.is_empty() and not GameState.beta_station_map_bought and not GameState.is_station_discovered("station_beta")
	buy_beta_station_map_button.visible = show_beta_map
	if show_beta_map:
		buy_beta_station_map_button.text = "Mapa para Posto Beta (marca no minimapa) (%s)" % _format_cost(beta_map_cost)
		buy_beta_station_map_button.disabled = not GameState.can_afford(beta_map_cost)

	var aux_have := GameState.get_artifact_parts("aux_ship")
	var aux_required := ArtifactDatabase.get_parts_required("aux_ship")
	var show_aux_shop := GameState.current_zone_id == "mid" and not aux_shop_cost.is_empty() and not GameState.aux_ship_shop_part_bought and not GameState.has_artifact("aux_ship") and aux_have < aux_required
	buy_aux_ship_part_button.visible = show_aux_shop
	if show_aux_shop:
		buy_aux_ship_part_button.text = "Comprar 1 peca Aux Ship (%s)" % _format_cost(aux_shop_cost)
		buy_aux_ship_part_button.disabled = not GameState.can_afford(aux_shop_cost)

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

	if show_artifact_part:
		var can_buy_part := (not GameState.artifact_completed) and GameState.can_afford(artifact_cost)
		buy_artifact_part_button.disabled = not can_buy_part

	var kit_cost: Dictionary = StationCatalog.get_repair_kit_cost(station_id)
	buy_repair_kit_button.text = "Kit de reparacao (+50%% HP) (%s)" % _format_cost(kit_cost)
	buy_repair_kit_button.disabled = not GameState.can_afford(kit_cost)

	var repair_cost: Dictionary = StationCatalog.get_ship_repair_cost(station_id)
	repair_ship_button.text = "Reparar nave (cura total) (%s)" % _format_cost(repair_cost)
	repair_ship_button.disabled = GameState.player_health >= GameState.player_max_health or not GameState.can_afford(repair_cost)

	_update_npc_button_text()
	var offered: Array = _get_offered_quests_for_active_npc()
	_offered_quest_id = ""
	if offered.size() > 0:
		_offered_quest_id = str(offered[0])
	_rebuild_station_quest_list(offered)
	_rebuild_delivery_list(station_id)
	_update_station_quest_buttons()
	_update_vault_ui()
	_update_bandit_qte_ui()

func _update_boss_planet_ui() -> void:
	if boss_planet_panel == null:
		return

	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var is_boss_planet := station_id == BOSS_PLANET_STATION_ID

	boss_planet_panel.visible = is_boss_planet
	if trader_tabs != null:
		trader_tabs.visible = not is_boss_planet

	if tavern_bottom_bar != null:
		tavern_bottom_bar.visible = false

	if not is_boss_planet:
		return

	var defeated := GameState.is_boss_defeated()
	var unlocked := GameState.has_boss_planet_resources_unlocked()
	if not defeated:
		boss_planet_info.text = "Derrota o boss para desbloquear a recompensa."
	elif unlocked:
		boss_planet_info.text = "Recompensa ja coletada."
	else:
		boss_planet_info.text = "Boss derrotado. Recompensa: 500 scrap + 200 mineral."

	if boss_planet_collect_button != null:
		boss_planet_collect_button.visible = defeated and not unlocked
		boss_planet_collect_button.disabled = not GameState.can_unlock_boss_planet_resources()

func _on_boss_planet_collect_pressed() -> void:
	if GameState.unlock_boss_planet_resources():
		GameState.add_resource("scrap", 500)
		GameState.add_resource("mineral", 200)
		_update_boss_planet_ui()

func _get_boss_node() -> Node:
	if _boss_node != null and is_instance_valid(_boss_node):
		return _boss_node
	var node := get_tree().get_first_node_in_group("boss")
	_boss_node = node
	return node

func _update_boss_health_ui() -> void:
	if boss_health_container == null:
		return

	var boss := _get_boss_node()
	if boss == null or not is_instance_valid(boss):
		boss_health_container.visible = false
		return

	var engaged := false
	if boss.has_method("is_boss_engaged"):
		engaged = bool(boss.call("is_boss_engaged"))
	else:
		engaged = bool(boss.get("boss_engaged"))

	if not engaged:
		boss_health_container.visible = false
		return

	var max_hp := int(boss.get("max_health"))
	if max_hp <= 0:
		boss_health_container.visible = false
		return

	var current_hp := int(boss.get("current_health"))
	if boss_health_bar != null:
		boss_health_bar.max_value = max_hp
		boss_health_bar.value = clamp(current_hp, 0, max_hp)
	if boss_health_label != null:
		boss_health_label.text = "BOSS"

	boss_health_container.visible = true

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
	_refresh_offered_quest()
	_update_knife_game_ui()

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

func _on_buy_vacuum_map_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_vacuum_map_cost(station_id)
	GameState.buy_vacuum_map(cost)

func _on_buy_alpha_station_map_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_station_alpha_map_cost(station_id)
	GameState.buy_alpha_station_map(cost)

func _on_buy_vacuum_part_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_vacuum_part_shop_cost(station_id)
	GameState.buy_vacuum_shop_part(station_id, cost)

func _on_buy_reverse_thruster_part_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_reverse_thruster_shop_part_cost(station_id)
	GameState.buy_reverse_thruster_shop_part(station_id, cost)

func _on_buy_reverse_thruster_map_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_reverse_thruster_map_cost(station_id)
	GameState.buy_reverse_thruster_map(station_id, cost)

func _on_buy_side_dash_part_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_side_dash_shop_part_cost(station_id)
	GameState.buy_side_dash_shop_part(station_id, cost)

func _on_buy_auto_regen_map_zone1_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_auto_regen_map_zone1_cost(station_id)
	GameState.buy_auto_regen_map_zone1(station_id, cost)

func _on_buy_auto_regen_map_zone2_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_auto_regen_map_zone2_cost(station_id)
	GameState.buy_auto_regen_map_zone2(station_id, cost)

func _on_buy_kappa_station_map_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_kappa_station_map_cost(station_id)
	GameState.buy_kappa_station_map(cost)

func _on_buy_beta_station_map_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_beta_station_map_cost(station_id)
	GameState.buy_beta_station_map(cost)

func _on_buy_aux_ship_part_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_aux_ship_shop_part_cost(station_id)
	GameState.buy_aux_ship_shop_part(station_id, cost)

func _on_debug_give_resources_pressed() -> void:
	GameState.debug_grant_test_resources()

func _on_debug_boss_planet_pressed() -> void:
	var quest_id := GameState.QUEST_BOSS_PLANET
	if not GameState.QUEST_DEFS.has(quest_id):
		return
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	if GameState.accept_quest(quest_id, station_id):
		_update_hud()

func _on_debug_unlock_all_gadgets_pressed() -> void:
	GameState.debug_unlock_all_gadgets()

func _on_buy_repair_kit_pressed() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_repair_kit_cost(station_id)
	GameState.buy_repair_kit(cost)

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
	_set_active_npc(npc)
	_start_dialogue(_active_station_id, str(npc.get("id", "")))

func _update_npc_button_text() -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var title := StationCatalog.get_station_title(station_id)
	_station_npcs = StationCatalog.get_station_npcs(station_id)
	if _station_npcs.is_empty():
		_station_npcs = _get_npcs_for_station(station_id)

	if _station_npcs.is_empty():
		_active_npc_id = ""
		_active_npc_type = ""
	else:
		var found := false
		for npc_variant in _station_npcs:
			if typeof(npc_variant) != TYPE_DICTIONARY:
				continue
			var npc: Dictionary = npc_variant
			if str(npc.get("id", "")) == _active_npc_id:
				_active_npc_type = str(npc.get("type", ""))
				found = true
				break
		if not found:
			_active_npc_id = ""
			_active_npc_type = ""

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

func _set_active_npc(npc: Dictionary) -> void:
	_active_npc_id = str(npc.get("id", ""))
	_active_npc_type = str(npc.get("type", ""))
	_refresh_offered_quest()
	_rebuild_station_quest_list(_get_offered_quests_for_active_npc())

func _refresh_offered_quest() -> void:
	_offered_quest_id = _pick_offered_quest_for_npc()
	_update_station_quest_buttons()

func _get_offered_quests_for_active_npc() -> Array:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	if _active_npc_id.is_empty() or _active_npc_type.is_empty():
		return []

	var pool := QuestDatabase.get_quest_pool(_active_npc_type)
	if pool.is_empty():
		return []

	var candidates: Array[String] = []
	for quest_id_variant in pool:
		var quest_id := str(quest_id_variant)
		if not QuestDatabase.is_quest_available_in_station(quest_id, station_id):
			continue
		candidates.append(quest_id)

	return GameState.filter_offered_quests(candidates)

func _pick_offered_quest_for_npc() -> String:
	var candidates := _get_offered_quests_for_active_npc()
	if candidates.is_empty():
		return ""

	var unclaimed: Array[String] = []
	for quest_id in candidates:
		var q: Dictionary = GameState.get_quest_state(quest_id)
		if bool(q.get("claimed", false)):
			continue
		unclaimed.append(quest_id)
		if bool(q.get("accepted", false)):
			return quest_id

	if unclaimed.is_empty():
		return ""
	return unclaimed[0]

func _on_knife_game_start_pressed() -> void:
	_start_knife_game()

func _on_bandit_qte_start_pressed() -> void:
	var quest_id := GameState.get_current_bandit_quest_id()
	if quest_id.is_empty():
		return
	_start_bandit_qte(quest_id)

func _start_knife_game() -> void:
	_knife_game_active = true
	_knife_game_score = 0
	_knife_game_sequence_index = 0
	_knife_game_time_left = KNIFE_GAME_ATTEMPT_TIME
	knife_game_result.text = ""
	knife_game_start_button.text = "Restart Knife Game"
	_update_knife_game_ui()

func _stop_knife_game() -> void:
	_knife_game_active = false
	_knife_game_score = 0
	_knife_game_sequence_index = 0
	_knife_game_time_left = 0.0
	knife_game_result.text = ""
	knife_game_start_button.text = "Start Knife Game"
	_update_knife_game_ui()

func _handle_knife_game_input(key_event: InputEventKey) -> bool:
	if not _knife_game_active:
		return false

	var keycode := key_event.keycode
	if keycode != KEY_A and keycode != KEY_S and keycode != KEY_D and keycode != KEY_W:
		return false

	if keycode != _get_expected_knife_keycode():
		_finish_knife_game("Erro: tecla errada.")
		return true

	_knife_game_score += 1
	_knife_game_sequence_index = (_knife_game_sequence_index + 1) % max(KNIFE_GAME_SEQUENCE.size(), 1)
	_update_knife_game_ui()
	return true

func _update_knife_game_prompt_text() -> void:
	if knife_game_prompt == null:
		return
	if not _knife_game_active:
		knife_game_prompt.text = "Press: -"
		return
	var key_name := _knife_game_key_name(_get_expected_knife_keycode())
	knife_game_prompt.text = "Press: %s (%.1fs)" % [key_name, max(_knife_game_time_left, 0.0)]

func _get_expected_knife_keycode() -> int:
	if KNIFE_GAME_SEQUENCE.is_empty():
		return KEY_A
	return int(KNIFE_GAME_SEQUENCE[_knife_game_sequence_index % KNIFE_GAME_SEQUENCE.size()])

func _knife_game_key_name(keycode: int) -> String:
	match keycode:
		KEY_A:
			return "A"
		KEY_S:
			return "S"
		KEY_D:
			return "D"
		KEY_W:
			return "W"
	return "?"

func _finish_knife_game(reason: String) -> void:
	_knife_game_active = false
	_knife_game_time_left = 0.0
	var station_id := _get_tavern_station_id()
	var result: Dictionary = GameState.record_tavern_score(station_id, _knife_game_score)
	var new_hi := bool(result.get("new_hi", false))
	var rewarded := bool(result.get("rewarded", false))
	var reward: Dictionary = result.get("reward", {}) as Dictionary
	if new_hi:
		var reward_text := ""
		if rewarded:
			reward_text = " Recompensa: %s" % _format_cost(reward)
		if not reason.is_empty():
			knife_game_result.text = "%s Novo hi-score!%s" % [reason, reward_text]
		else:
			knife_game_result.text = "Novo hi-score!%s" % reward_text
	else:
		knife_game_result.text = reason
	knife_game_start_button.text = "Start Knife Game"
	_update_knife_game_ui()

func _update_knife_game_ui() -> void:
	if knife_game_high_score == null or knife_game_score == null:
		return
	var station_id := _get_tavern_station_id()
	var hi := GameState.get_tavern_hi_score(station_id)
	knife_game_high_score.text = "Hi-score: %d" % hi
	knife_game_score.text = "Score: %d" % _knife_game_score
	_update_knife_game_prompt_text()

func _update_boss_compass() -> void:
	if _boss_arrow != null and not is_instance_valid(_boss_arrow):
		_boss_arrow = null

	var show := GameState.should_show_boss_compass()
	if not show:
		if _boss_arrow != null:
			_boss_arrow.visible = false
		return

	var ship_node := get_tree().get_first_node_in_group("ship")
	if not (ship_node is Node2D):
		ship_node = get_tree().get_first_node_in_group("player")
	if not (ship_node is Node2D):
		if _boss_arrow != null:
			_boss_arrow.visible = false
		return

	var marker_node := get_tree().get_first_node_in_group("boss_planet_marker")
	var ship := ship_node as Node2D
	var target_pos: Vector2
	if marker_node is Node2D:
		target_pos = (marker_node as Node2D).global_position
	else:
		var manager := get_tree().get_first_node_in_group("zone_manager")
		if manager != null:
			var zone_offset: Vector2 = Vector2.ZERO
			var zone_scale: Vector2 = Vector2.ONE
			var offset_value: Variant = manager.get("zone_offset")
			if offset_value is Vector2:
				zone_offset = offset_value
			var scale_value: Variant = manager.get("zone_scale")
			if scale_value is Vector2:
				zone_scale = scale_value
			target_pos = zone_offset + BOSS_PLANET_FALLBACK_POS * zone_scale
		else:
			target_pos = BOSS_PLANET_FALLBACK_POS

	var dir := target_pos - ship.global_position
	if dir.length() <= 0.001:
		if _boss_arrow != null:
			_boss_arrow.visible = false
		return
	dir = dir.normalized()

	if _boss_arrow == null:
		_boss_arrow = Sprite2D.new()
		_boss_arrow.texture = BOSS_ARROW_TEXTURE
		_boss_arrow.centered = true
		_boss_arrow.z_index = 100
		_boss_arrow.scale = Vector2(0.15, 0.15)

	var root := get_tree().current_scene
	if root != null and _boss_arrow.get_parent() != root:
		if _boss_arrow.get_parent() != null:
			_boss_arrow.get_parent().remove_child(_boss_arrow)
		root.add_child(_boss_arrow)

	_boss_arrow.visible = true
	_boss_arrow.global_position = ship.global_position + dir * BOSS_ARROW_RADIUS
	_boss_arrow.rotation = dir.angle()

func _start_bandit_qte(quest_id: String) -> void:
	if _bandit_qte_active or quest_id.is_empty():
		return
	var def: Dictionary = GameState.QUEST_DEFS.get(quest_id, {}) as Dictionary
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var target_station_id := str(def.get("target_station_id", ""))
	if not target_station_id.is_empty() and target_station_id != station_id:
		return
	var q: Dictionary = GameState.get_quest_state(quest_id)
	if not bool(q.get("accepted", false)) or bool(q.get("completed", false)):
		return
	var steps := int(def.get("qte_steps", 6))
	if steps < 1:
		steps = 1
	var time_per := float(def.get("qte_time", 1.0))
	if time_per < 0.2:
		time_per = 0.2

	_bandit_qte_sequence = []
	for _i in range(steps):
		var idx := randi() % BANDIT_QTE_KEYS.size()
		_bandit_qte_sequence.append(BANDIT_QTE_KEYS[idx])

	_bandit_qte_active = true
	_bandit_qte_quest_id = quest_id
	_bandit_qte_steps = steps
	_bandit_qte_time_per_step = time_per
	_bandit_qte_index = 0
	_bandit_qte_time_left = _bandit_qte_time_per_step
	_bandit_qte_last_failed = false
	if bandit_qte_result != null:
		bandit_qte_result.text = ""
	_stop_knife_game()
	_update_bandit_qte_ui()

func _stop_bandit_qte() -> void:
	_bandit_qte_active = false
	_bandit_qte_sequence.clear()
	_bandit_qte_index = 0
	_bandit_qte_time_left = 0.0
	_bandit_qte_time_per_step = 0.0
	_bandit_qte_steps = 0
	_bandit_qte_quest_id = ""
	_bandit_qte_last_failed = false
	if bandit_qte_result != null:
		bandit_qte_result.text = ""
	_update_bandit_qte_ui()

func _handle_bandit_qte_input(key_event: InputEventKey) -> bool:
	if not _bandit_qte_active:
		return false
	var keycode := key_event.keycode
	if not BANDIT_QTE_KEYS.has(keycode):
		return false
	if keycode != _get_bandit_qte_expected_keycode():
		_finish_bandit_qte(false, "Falhaste a tecla.")
		return true

	_bandit_qte_index += 1
	if _bandit_qte_index >= _bandit_qte_steps:
		_finish_bandit_qte(true, "Bandido derrotado.")
		return true

	_bandit_qte_time_left = _bandit_qte_time_per_step
	_update_bandit_qte_ui()
	return true

func _get_bandit_qte_expected_keycode() -> int:
	if _bandit_qte_sequence.is_empty():
		return KEY_W
	return int(_bandit_qte_sequence[_bandit_qte_index % _bandit_qte_sequence.size()])

func _bandit_qte_key_name(keycode: int) -> String:
	match keycode:
		KEY_W:
			return "W"
		KEY_A:
			return "A"
		KEY_S:
			return "S"
		KEY_D:
			return "D"
	return "?"

func _update_bandit_qte_prompt_text() -> void:
	if bandit_qte_prompt == null:
		return
	if not _bandit_qte_active:
		bandit_qte_prompt.text = "Tecla: -"
		return
	var key_name := _bandit_qte_key_name(_get_bandit_qte_expected_keycode())
	var time_left := _bandit_qte_time_left
	if time_left < 0.0:
		time_left = 0.0
	bandit_qte_prompt.text = "Tecla: %s (%.1fs)" % [key_name, time_left]

func _update_bandit_qte_ui() -> void:
	if bandit_qte_panel == null:
		return
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var quest_id := GameState.get_current_bandit_quest_id()
	if _bandit_qte_active and not _bandit_qte_quest_id.is_empty():
		quest_id = _bandit_qte_quest_id
	var show := false
	var accepted := false
	var completed := false
	var target_station_id := ""
	if not quest_id.is_empty():
		var def: Dictionary = GameState.QUEST_DEFS.get(quest_id, {}) as Dictionary
		target_station_id = str(def.get("target_station_id", ""))
		var q: Dictionary = GameState.get_quest_state(quest_id)
		accepted = bool(q.get("accepted", false))
		completed = bool(q.get("completed", false))
		show = accepted and not completed and station_id == target_station_id
	if _bandit_qte_active:
		show = true
	if bandit_qte_result != null and not bandit_qte_result.text.is_empty():
		show = true

	bandit_qte_panel.visible = show
	if bandit_qte_separator != null:
		bandit_qte_separator.visible = show

	if not show:
		return

	var def2: Dictionary = GameState.QUEST_DEFS.get(quest_id, {}) as Dictionary
	var steps := _bandit_qte_steps
	var time_per := _bandit_qte_time_per_step
	if not _bandit_qte_active:
		steps = int(def2.get("qte_steps", 0))
		time_per = float(def2.get("qte_time", 0.0))
	var idx := GameState.get_bandit_quest_index(quest_id)
	var title := str(def2.get("title", "Duelo"))
	if bandit_qte_info != null:
		bandit_qte_info.text = "%s (dificuldade %d/5)\nAcerta %d teclas (%.1fs por tecla)." % [title, idx, steps, time_per]
	if bandit_qte_progress != null:
		bandit_qte_progress.text = "Passos: %d/%d" % [_bandit_qte_index, steps]
	if bandit_qte_start_button != null:
		bandit_qte_start_button.visible = show
		var can_start := (not quest_id.is_empty()) and accepted and (not completed) and (station_id == target_station_id)
		bandit_qte_start_button.disabled = _bandit_qte_active or not can_start
		if _bandit_qte_last_failed:
			bandit_qte_start_button.text = "Tentar de novo"
		else:
			bandit_qte_start_button.text = "Comecar duelo"
	_update_bandit_qte_prompt_text()

func _finish_bandit_qte(success: bool, reason: String) -> void:
	_bandit_qte_active = false
	_bandit_qte_index = 0
	_bandit_qte_sequence.clear()
	_bandit_qte_time_left = 0.0
	if success and not _bandit_qte_quest_id.is_empty():
		GameState.complete_quest(_bandit_qte_quest_id)
		_bandit_qte_last_failed = false
		if bandit_qte_result != null:
			var idx := GameState.get_bandit_quest_index(_bandit_qte_quest_id)
			if idx >= 5:
				bandit_qte_result.text = "Vitoria final. O ultimo bandido cai."
			else:
				bandit_qte_result.text = "Vitoria. [Bandido]: Nao vou deixar isto passar."
	else:
		_bandit_qte_last_failed = true
		if bandit_qte_result != null:
			var fail_text := reason
			if not fail_text.is_empty():
				fail_text += " "
			bandit_qte_result.text = "%s[Bandido]: Tenta outra vez, turista." % fail_text
	_bandit_qte_quest_id = ""
	_update_station_quest_buttons()
	_update_bandit_qte_ui()

func _get_tavern_station_id() -> String:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	return station_id

func _get_npcs_for_station(station_id: String) -> Array:
	match station_id:
		"station_alpha":
			return [
				{"id": "glip", "name": "Glip-Glop", "type": "scavenger"},
				{"id": "zorbo", "name": "Zorbo o Pegajoso", "type": "bruiser"},
				{"id": "mnem", "name": "Mnem-8", "type": "bounty"},
			]
		"station_beta":
			return [
				{"id": "bloop", "name": "Bloop", "type": "scavenger"},
				{"id": "krrth", "name": "Krr'th", "type": "marksman"},
				{"id": "snee", "name": "Snee-Snack", "type": "bounty"},
			]
		"station_gamma":
			return [
				{"id": "vexa", "name": "Vexa", "type": "bounty"},
				{"id": "oomu", "name": "Oomu", "type": "scavenger"},
				{"id": "rrrl", "name": "Rrrl", "type": "bruiser"},
			]
		"station_delta":
			return [
				{"id": "bandit", "name": "Bandido", "type": "hunter"},
				{"id": "krrth", "name": "Krr'th", "type": "marksman"},
				{"id": "snee", "name": "Snee-Snack", "type": "scavenger"},
			]
		"station_epsilon":
			return [
				{"id": "hunter", "name": "Cacador", "type": "hunter"},
				{"id": "vexa", "name": "Vexa", "type": "bounty"},
				{"id": "rrrl", "name": "Rrrl", "type": "bruiser"},
			]
		_:
			return [
				{"id": "alien1", "name": "Alien Aleatorio", "type": "bounty"},
				{"id": "alien2", "name": "Alien Aleatorio 2", "type": "bounty"},
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
	nodes = _inject_npc_quest_nodes(nodes, station_id, npc_id)
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
			var arg := str(parts[2])
			var next_after := "end"
			if parts.size() >= 4:
				next_after = str(parts[3])

			match action:
				"accept_quest":
					var station_id := _active_station_id
					if station_id.is_empty():
						station_id = DEFAULT_STATION_ID
					GameState.accept_quest(arg, station_id)
					if arg == QuestDatabase.QUEST_MINE_4_AMETISTA:
						GameState.give_zone2_mining_drill_near_player()
						_set_trader_menu_visible(false)
				"claim_quest":
					var station_id2 := _active_station_id
					if station_id2.is_empty():
						station_id2 = DEFAULT_STATION_ID
					GameState.claim_quest(arg, station_id2)
				"start_bandit_qte":
					_start_bandit_qte(arg)
				"discover_station":
					GameState.discover_station(arg)

			_update_station_quest_buttons()
			_update_bandit_qte_ui()

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

func _inject_npc_quest_nodes(nodes: Dictionary, station_id: String, npc_id: String) -> Dictionary:
	if nodes.is_empty():
		return nodes
	if npc_id == "hunter" or npc_id == "bandit":
		return nodes

	var quest_id := _pick_offered_quest_for_npc()
	if quest_id.is_empty():
		return nodes

	var def: Dictionary = GameState.QUEST_DEFS.get(quest_id, {}) as Dictionary
	if def.is_empty():
		return nodes

	var start: Dictionary = nodes.get("start", {}) as Dictionary
	if start.is_empty():
		return nodes

	var q: Dictionary = GameState.get_quest_state(quest_id)
	var accepted := bool(q.get("accepted", false))
	var completed := bool(q.get("completed", false))
	var claimed := bool(q.get("claimed", false))
	var title := str(def.get("title", "Missao"))
	var description := str(def.get("description", ""))
	var goal: int = int(def.get("goal", 0))
	var progress: int = int(q.get("progress", 0))

	var choices: Array = start.get("choices", []) as Array
	choices = choices.duplicate()

	var quest_choice_index := -1
	for i in range(choices.size()):
		if typeof(choices[i]) != TYPE_DICTIONARY:
			continue
		var c: Dictionary = choices[i]
		var next := str(c.get("next", ""))
		var text := str(c.get("text", ""))
		if next == "quest" or text.findn("missao") >= 0:
			quest_choice_index = i
			break

	if not accepted:
		if quest_choice_index >= 0:
			var c: Dictionary = choices[quest_choice_index]
			c["text"] = "Tens uma missao?"
			c["next"] = "npc_quest_offer"
			choices[quest_choice_index] = c
		else:
			choices.append({"text": "Tens uma missao?", "next": "npc_quest_offer"})
		nodes["npc_quest_offer"] = {
			"text": "Missao: %s\n%s" % [title, description],
			"choices": [
				{"text": "Aceitar.", "next": "action:accept_quest:%s:end" % quest_id},
				{"text": "Agora nao.", "next": "end"},
			],
		}
	elif completed and not claimed:
		if quest_choice_index >= 0:
			var c2: Dictionary = choices[quest_choice_index]
			c2["text"] = "Tenho a missao pronta."
			c2["next"] = "npc_quest_reward"
			choices[quest_choice_index] = c2
		else:
			choices.append({"text": "Tenho a missao pronta.", "next": "npc_quest_reward"})
		var can_claim := GameState.can_claim_quest_at_station(quest_id, station_id)
		var reward_text := "Missao concluida: %s." % title
		var reward_choices: Array = []
		if can_claim:
			reward_text += "\nQueres receber a recompensa?"
			reward_choices = [
				{"text": "Receber recompensa.", "next": "action:claim_quest:%s:end" % quest_id},
				{"text": "Depois.", "next": "end"},
			]
		else:
			var accepted_station_id := str(q.get("accepted_station_id", ""))
			if not accepted_station_id.is_empty():
				reward_text += "\nEntrega em: %s." % StationCatalog.get_station_title(accepted_station_id)
			else:
				reward_text += "\nEntrega noutra estacao."
			reward_choices = [
				{"text": "Ok.", "next": "end"},
			]
		nodes["npc_quest_reward"] = {
			"text": reward_text,
			"choices": reward_choices,
		}
	elif accepted and not completed:
		if quest_choice_index >= 0:
			var c3: Dictionary = choices[quest_choice_index]
			c3["text"] = "Sobre a missao..."
			c3["next"] = "npc_quest_status"
			choices[quest_choice_index] = c3
		else:
			choices.append({"text": "Sobre a missao...", "next": "npc_quest_status"})
		nodes["npc_quest_status"] = {
			"text": "Missao: %s\nProgresso: %d/%d" % [title, progress, goal],
			"choices": [
				{"text": "Ok.", "next": "end"},
			],
		}
	else:
		if quest_choice_index >= 0:
			var c4: Dictionary = choices[quest_choice_index]
			c4["text"] = "Sobre a missao..."
			c4["next"] = "npc_quest_status"
			choices[quest_choice_index] = c4
		else:
			choices.append({"text": "Sobre a missao...", "next": "npc_quest_status"})
		nodes["npc_quest_status"] = {
			"text": "Missao: %s.\nSem trabalho novo por agora." % title,
			"choices": [
				{"text": "Ok.", "next": "end"},
			],
		}

	start["choices"] = choices
	nodes["start"] = start
	return nodes

func _get_dialogue_nodes(station_id: String, npc_id: String) -> Dictionary:
	# Conversas engraçadas com escolhas.
	match npc_id:
		"hunter":
			var quest_id := GameState.get_current_bandit_quest_id()
			if quest_id.is_empty():
				var boss_id := GameState.QUEST_BOSS_PLANET
				if not GameState.QUEST_DEFS.has(boss_id):
					return {
						"start": {
							"text": "[b]Cacador[/b]: Ja nao tenho mais bandidos para ti. Bom trabalho.",
							"choices": [
								{"text": "Ok.", "next": "end"},
							],
						},
					}

				var boss_q: Dictionary = GameState.get_quest_state(boss_id)
				var boss_accepted := bool(boss_q.get("accepted", false))
				var boss_completed := bool(boss_q.get("completed", false))
				var boss_claimed := bool(boss_q.get("claimed", false))
				if not boss_accepted:
					return {
						"start": {
							"text": "[b]Cacador[/b]: Agora a coisa e seria. Descobri um planeta fora do mapa.\n[b]Cacador[/b]: Um boss ronda a zona. Se o derrubares, a peca do artefacto e tua.\n[b]Cacador[/b]: Enviei o marcador para o teu mapa.",
							"choices": [
								{"text": "Aceitar missao.", "next": "action:accept_quest:%s:accepted" % boss_id},
								{"text": "Agora nao.", "next": "end"},
							],
						},
						"accepted": {
							"text": "[b]Cacador[/b]: Vai la e acaba com ele. O planeta esta fora do mapa, segue o marcador.",
							"choices": [
								{"text": "Ok.", "next": "end"},
							],
						},
					}

				if boss_accepted and not boss_completed:
					return {
						"start": {
							"text": "[b]Cacador[/b]: O boss ainda ronda o planeta. Vai la e trata disso.",
							"choices": [
								{"text": "Estou a caminho.", "next": "end"},
							],
						},
					}

				if boss_completed and not boss_claimed:
					return {
						"start": {
							"text": "[b]Cacador[/b]: Conseguiste? O marcador confirmou a queda.\n[b]Cacador[/b]: Queres fechar isto agora?",
							"choices": [
								{"text": "Fechar missao.", "next": "action:claim_quest:%s:rewarded" % boss_id},
								{"text": "Depois.", "next": "end"},
							],
						},
						"rewarded": {
							"text": "[b]Cacador[/b]: Bom trabalho. Agora tens o warp para a proxima zona.",
							"choices": [
								{"text": "Obrigado.", "next": "end"},
							],
						},
					}

				return {
					"start": {
						"text": "[b]Cacador[/b]: Ja nao tenho mais trabalho para ti. Descansa.",
						"choices": [
							{"text": "Ok.", "next": "end"},
						],
					},
				}

			var hunter_q: Dictionary = GameState.get_quest_state(quest_id)
			var hunter_accepted := bool(hunter_q.get("accepted", false))
			var hunter_completed := bool(hunter_q.get("completed", false))
			var hunter_claimed := bool(hunter_q.get("claimed", false))
			var def: Dictionary = GameState.QUEST_DEFS.get(quest_id, {}) as Dictionary
			var title := str(def.get("title", "Missao"))
			var idx := GameState.get_bandit_quest_index(quest_id)
			var description := str(def.get("description", ""))
			var mission_label := "%s (%d/5)" % [title, idx]

			if not hunter_accepted:
				return {
					"start": {
						"text": "[b]Cacador[/b]: Tenho um novo alvo.\n[b]Cacador[/b]: %s\n[b]Cacador[/b]: %s. Aceitas?" % [description, mission_label],
						"choices": [
							{"text": "Aceitar missao.", "next": "action:accept_quest:%s:accepted" % quest_id},
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
						"text": "[b]Cacador[/b]: Ainda estas aqui? O Bandido esta no Mercador Delta.\n[b]Cacador[/b]: Derrota-o e volta para receber a recompensa.",
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
							{"text": "Receber recompensa.", "next": "action:claim_quest:%s:rewarded" % quest_id},
							{"text": "Depois.", "next": "end"},
						],
					},
					"rewarded": {
						"text": "[b]Cacador[/b]: Aqui esta a recompensa.",
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
			var quest_id := GameState.get_current_bandit_quest_id()
			if quest_id.is_empty():
				return {
					"start": {
						"text": "[b]Bandido[/b]: ...",
						"choices": [
							{"text": "Ok.", "next": "end"},
						],
					},
				}

			var bandit_q: Dictionary = GameState.get_quest_state(quest_id)
			var bandit_accepted := bool(bandit_q.get("accepted", false))
			var bandit_completed := bool(bandit_q.get("completed", false))
			var idx := GameState.get_bandit_quest_index(quest_id)

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
						"text": "[b]Bandido[/b]: Eh, turista. Vieste pelo duelo ou so pelo cheiro a sopa?\n[b]Bandido[/b]: Eu nao perco para quem derrama mineral ao beber.",
						"choices": [
							{"text": "Quero duelar.", "next": "duel_intro"},
							{"text": "Conta uma piada.", "next": "joke"},
							{"text": "Adeus.", "next": "end"},
						],
					},
					"joke": {
						"text": "[b]Bandido[/b]: Um dia tentei ser honesto. Foi o pior assalto da minha vida.",
						"choices": [
							{"text": "Ok, duelo.", "next": "duel_intro"},
							{"text": "Voltar.", "next": "start"},
						],
					},
					"duel_intro": {
						"text": "[b]Bandido[/b]: Duelo %d/5. WASD, sem choro.\n[b]Bandido[/b]: Se falhares, vou gozar por semanas." % idx,
						"choices": [
							{"text": "Comecar duelo.", "next": "action:start_bandit_qte:%s:end" % quest_id},
							{"text": "Ainda nao.", "next": "end"},
						],
					},
				}

			if bandit_completed:
				if idx >= 5:
					return {
						"start": {
							"text": "[b]Bandido[/b]: Ok... desta vez ganhaste.\n[b]Bandido[/b]: Diz ao Cacador que acabou.",
							"choices": [
								{"text": "Adeus.", "next": "end"},
							],
						},
					}
				return {
					"start": {
						"text": "[b]Bandido[/b]: Nao vou deixar isto passar.\n[b]Bandido[/b]: Isto ainda nao acabou.",
						"choices": [
							{"text": "Veremos.", "next": "end"},
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
						{"text": "Tens trabalho?", "next": "work"},
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
				"work": {
					"text": "[b]Glip-Glop[/b]: Trabalho? Sim! O setor precisa de limpeza.\n[b]Glip-Glop[/b]: Se matares 20 basicos, dou-te uma recompensa decente.\n[b]Glip-Glop[/b]: Ou... se juntares 50 scrap, tambem pago bem.",
					"choices": [
						{"text": "Ok.", "next": "end"},
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
			var krrth_nodes: Dictionary = {
				"start": {
					"text": "[b]Krr'th[/b]: Eu negocio apenas em tres coisas: mineral, scrap... e drama.\n[b]Bloop[/b]: Ele cobra taxa de drama.\n[b]Krr'th[/b]: E dedutivel!",
					"choices": [
						{"text": "Quanto custa 1 drama?", "next": "cost"},
						{"text": "Diz-me algo estranho.", "next": "weird"},
						{"text": "Tens uma missao?", "next": "mission"},
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
				"mission": {
					"text": "[b]Krr'th[/b]: Missao? Sim. Os snipers estao a incomodar.\n[b]Krr'th[/b]: Mata 8 deles e dou-te uma recompensa. Drama incluido.",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
			}
			# Mercador Delta: missão de sniper
			if station_id == "station_delta":
				var start: Dictionary = krrth_nodes.get("start", {}) as Dictionary
				var choices: Array = (start.get("choices", []) as Array).duplicate()
				start["choices"] = choices
				krrth_nodes["start"] = start
			return krrth_nodes
		"bloop":
			var bloop_nodes: Dictionary = {
				"start": {
					"text": "[b]Bloop[/b]: *bloop* *bloop*\n[b]Tu[/b]: Isso foi uma frase?\n[b]Bloop[/b]: Sim. Disse que o teu capacete parece uma panela.",
					"choices": [
						{"text": "Ofensivo.", "next": "offense"},
						{"text": "Obrigado?", "next": "thanks"},
						{"text": "Tens trabalho?", "next": "work"},
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
				"work": {
					"text": "[b]Bloop[/b]: *bloop* Sim. Preciso de mineral. Muito mineral.\n[b]Bloop[/b]: Se juntares 100, dou-te uma recompensa especial. *bloop*",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
			}
			# Outpost Beta: missão de mineral
			if station_id == "station_beta":
				var start: Dictionary = bloop_nodes.get("start", {}) as Dictionary
				var choices: Array = (start.get("choices", []) as Array).duplicate()
				start["choices"] = choices
				bloop_nodes["start"] = start
			return bloop_nodes
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
			var nodes: Dictionary = {
				"start": {
					"text": "[b]Vexa[/b]: Bem-vindo. Aqui servimos duas coisas: silencio e historias.\n[b]Tu[/b]: E comida?\n[b]Vexa[/b]: As historias alimentam. (mentira, mas funciona.)",
					"choices": [
						{"text": "Conta uma historia.", "next": "story"},
						{"text": "Tenho uma pergunta.", "next": "question"},
						{"text": "Tens trabalho?", "next": "work"},
						{"text": "Adeus.", "next": "end"},
					],
				},
				"work": {
					"text": "[b]Vexa[/b]: Trabalho? Sim. Preciso de um explorador.\n[b]Vexa[/b]: Descobre 2 estações novas e dou-te uma recompensa. E um mapa.",
					"choices": [
						{"text": "Ok.", "next": "end"},
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

			# Refugio Epsilon: Vexa revela o Mercador Delta e marca no minimapa.
			if station_id == "station_epsilon":
				var start: Dictionary = nodes.get("start", {}) as Dictionary
				var choices: Array = (start.get("choices", []) as Array).duplicate()

				if GameState.is_station_discovered("station_delta"):
					nodes["delta_info"] = {
						"text": "[b]Vexa[/b]: O Mercador Delta ja esta marcado. Nao te percas... a nao ser que queiras.\n[b]Tu[/b]: Reconfortante.",
						"choices": [
							{"text": "Vou la ver.", "next": "end"},
						],
					}
					choices.insert(0, {"text": "E sobre o Mercador Delta...", "next": "delta_info"})
				else:
					nodes["delta_info"] = {
						"text": "[b]Vexa[/b]: Mercador Delta? Vendedores, gargalhadas e negociacoes suspeitas.\nFica longe daqui: segue para o quadrante inferior-esquerdo da zona.\n(Pronto. Marquei-te no mapa.)",
						"choices": [
							{"text": "Perfeito.", "next": "end"},
						],
					}
					choices.insert(0, {"text": "Onde fica o Mercador Delta?", "next": "action:discover_station:station_delta:delta_info"})

				start["choices"] = choices
				nodes["start"] = start

			# Posto Kappa (Zona 2): intro de mineração.
			if station_id == "station_kappa":
				nodes["start"] = {
					"text": "[b]Vexa[/b]: Ah, és novo por estas bandas?\nAqui temos um minério especial. Se me apanhas quatro com esta broca, dou-te uma recompensa.",
					"choices": [
						{"text": "Missao.", "next": "quest"},
						{"text": "Ok.", "next": "end"},
					],
				}

			return nodes
		"oomu":
			var oomu_nodes: Dictionary = {
				"start": {
					"text": "[b]Oomu[/b]: Eu nao vendo nada. Eu so observo.\n[b]Rrrl[/b]: Ele observa e depois cobra.\n[b]Oomu[/b]: Detalhes.",
					"choices": [
						{"text": "O que observas?", "next": "observe"},
						{"text": "Tens trabalho?", "next": "work"},
						{"text": "Adeus.", "next": "end"},
					],
				},
				"observe": {
					"text": "[b]Oomu[/b]: Observo o momento exato em que o player acha que esta seguro.\n[b]Tu[/b]: Isso e sinistro.\n[b]Oomu[/b]: Sim. E preciso.",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
				"work": {
					"text": "[b]Oomu[/b]: Observo que precisas de um componente de regeneração.\n[b]Oomu[/b]: Mata 20 inimigos (qualquer tipo) e dou-te a peca. Observado.",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
			}
			# Base Gamma: missão de auto regen
			if station_id == "station_gamma":
				var start: Dictionary = oomu_nodes.get("start", {}) as Dictionary
				var choices: Array = (start.get("choices", []) as Array).duplicate()
				start["choices"] = choices
				oomu_nodes["start"] = start
			return oomu_nodes
		"rrrl":
			return {
				"start": {
					"text": "[b]Rrrl[/b]: Rrrl.\n[b]Tu[/b]: Isso e um nome ou um aviso?\n[b]Rrrl[/b]: Sim.",
					"choices": [
						{"text": "Justo.", "next": "end"},
					],
				},
			}
		"hrrp":
			return {
				"start": {
					"text": "[b]Hrrp[/b]: Hrrp.\n[b]Tu[/b]: Isso e um cumprimento?\n[b]Hrrp[/b]: Hrrp. Sim. E tambem um aviso.\n[b]Hrrp[/b]: Os snipers estao a ficar perigosos. Mata 25 deles e dou-te ametista.",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
			}
		"nox":
			return {
				"start": {
					"text": "[b]Nox-7[/b]: Nox-7 ao servico.\n[b]Tu[/b]: Servico de que?\n[b]Nox-7[/b]: De limpeza. E de historias. E de sopa.\n[b]Nox-7[/b]: Mas principalmente de limpeza.",
					"choices": [
						{"text": "Ok.", "next": "end"},
					],
				},
			}
		"glunk":
			return {
				"start": {
					"text": "[b]Glunk[/b]: Glunk.\n[b]Tu[/b]: ...\n[b]Glunk[/b]: Glunk significa 'tenho trabalho se quiseres'.",
					"choices": [
						{"text": "Ok.", "next": "end"},
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

	if GameState.is_bandit_quest(_offered_quest_id):
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
				GameState.accept_quest(_offered_quest_id, station_id)
		elif station_id == target_station_id:
			if accepted and not completed:
				_start_bandit_qte(_offered_quest_id)

		_update_station_quest_buttons()
		return

	var station_id2 := _active_station_id
	if station_id2.is_empty():
		station_id2 = DEFAULT_STATION_ID
	GameState.accept_quest(_offered_quest_id, station_id2)
	_update_station_quest_buttons()

func _on_claim_station_quest() -> void:
	if _offered_quest_id.is_empty():
		return
	if GameState.is_bandit_quest(_offered_quest_id):
		return
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	GameState.claim_quest(_offered_quest_id, station_id)
	_update_station_quest_buttons()

func _rebuild_delivery_list(station_id: String) -> void:
	if delivery_list == null:
		return

	for child in delivery_list.get_children():
		delivery_list.remove_child(child)
		child.queue_free()

	var any := false
	for quest_id_variant in GameState.QUEST_DEFS.keys():
		var quest_id := str(quest_id_variant)
		if GameState.is_bandit_quest(quest_id):
			continue

		var q: Dictionary = GameState.get_quest_state(quest_id)
		if q.is_empty():
			continue
		if not bool(q.get("accepted", false)):
			continue
		if not bool(q.get("completed", false)):
			continue
		if bool(q.get("claimed", false)) or bool(q.get("archived", false)):
			continue

		var accepted_station_id := str(q.get("accepted_station_id", ""))
		if not accepted_station_id.is_empty() and accepted_station_id != station_id:
			continue

		any = true
		var def: Dictionary = GameState.QUEST_DEFS.get(quest_id, {}) as Dictionary
		var title := str(def.get("title", quest_id))

		var b := Button.new()
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.text = "Entregar: %s (%s)" % [title, _format_quest_rewards(def)]
		b.pressed.connect(_on_deliver_quest.bind(quest_id))
		delivery_list.add_child(b)

		var sep := HSeparator.new()
		sep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		delivery_list.add_child(sep)

	if not any:
		var l := Label.new()
		l.text = "Nenhuma missao pronta para entregar nesta estacao."
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		delivery_list.add_child(l)

func _on_deliver_quest(quest_id: String) -> void:
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	GameState.claim_quest(quest_id, station_id)
	_update_hud()
	_rebuild_delivery_list(station_id)

func _update_station_quest_buttons() -> void:
	accept_kill_quest_button.disabled = true
	claim_station_quest_button.disabled = true
	accept_kill_quest_button.text = "Sem missoes aqui"
	claim_station_quest_button.text = "Entregar missao (recompensa)"

	if _offered_quest_id.is_empty():
		if station_quest_details != null:
			station_quest_details.bbcode_enabled = true
			if _active_npc_id.is_empty():
				station_quest_details.text = "Fala com um NPC para ver missoes."
			else:
				station_quest_details.text = "Seleciona uma missao na lista."
		return

	if GameState.is_bandit_quest(_offered_quest_id):
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
				accept_kill_quest_button.text = "Derrotar Bandido (QTE)"
				accept_kill_quest_button.disabled = _bandit_qte_active
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
	var station_id2 := _active_station_id
	if station_id2.is_empty():
		station_id2 = DEFAULT_STATION_ID
	claim_station_quest_button.disabled = not GameState.can_claim_quest_at_station(_offered_quest_id, station_id2)
	_set_station_quest_details(_offered_quest_id)
	_set_station_quest_details(_offered_quest_id)

func _rebuild_station_quest_list(offered: Array) -> void:
	if station_quest_list == null:
		return

	for child in station_quest_list.get_children():
		station_quest_list.remove_child(child)
		child.queue_free()

	if _active_npc_id.is_empty():
		var hint := Label.new()
		hint.text = "Fala com um NPC para ver missoes."
		station_quest_list.add_child(hint)
		return

	if offered.is_empty():
		var l := Label.new()
		l.text = "Sem missoes para este NPC."
		station_quest_list.add_child(l)
		return

	var valid_ids: Array[String] = []
	for quest_id_variant in offered:
		var quest_id := str(quest_id_variant)
		if GameState.QUEST_DEFS.has(quest_id):
			valid_ids.append(quest_id)

	if valid_ids.is_empty():
		var l2 := Label.new()
		l2.text = "Sem missoes validas aqui."
		station_quest_list.add_child(l2)
		return

	for i in range(valid_ids.size()):
		var quest_id := valid_ids[i]
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
		if i < valid_ids.size() - 1:
			var sep := HSeparator.new()
			sep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			station_quest_list.add_child(sep)

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

	var accepted_station_id := str(q.get("accepted_station_id", ""))
	var delivery_hint := "Entrega em: %s" % StationCatalog.get_station_titles_offering_quest(quest_id)
	if not accepted_station_id.is_empty():
		delivery_hint = "Entrega em: %s" % StationCatalog.get_station_title(accepted_station_id)
	if GameState.is_bandit_quest(quest_id):
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

func _on_repair_ship_pressed() -> void:
	if _active_station == null:
		return
	var station_id := _active_station_id
	if station_id.is_empty():
		station_id = DEFAULT_STATION_ID
	var cost: Dictionary = StationCatalog.get_ship_repair_cost(station_id)
	GameState.repair_ship(cost)

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
		if GameState.is_bandit_quest(quest_id):
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
		var accepted_station_id := str(q.get("accepted_station_id", ""))
		var deliver := StationCatalog.get_station_titles_offering_quest(quest_id)
		if not accepted_station_id.is_empty():
			deliver = StationCatalog.get_station_title(accepted_station_id)
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

		if completed:
			var clear := Button.new()
			clear.text = "Limpar missao" if claimed else "Limpar (perde recompensa)"
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
	_rebuild_missions_list()

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

	var companion_header := Label.new()
	companion_header.text = "Companheiros"
	inventory_list.add_child(companion_header)

	var aux_goal := ArtifactDatabase.get_parts_required("aux_ship")
	var aux_progress := GameState.get_artifact_parts("aux_ship")
	var aux_done := GameState.has_artifact("aux_ship")
	var aux_item := RichTextLabel.new()
	aux_item.bbcode_enabled = true
	aux_item.scroll_active = false
	aux_item.fit_content = false
	aux_item.custom_minimum_size = Vector2(0, 110)
	aux_item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	aux_item.text = "[b]%s[/b]\nProgresso: %d/%d\nEstado: %s\nAjuda a matar inimigos automaticamente (dispara lasers)." % [
		ArtifactDatabase.get_artifact_title("aux_ship"),
		aux_progress,
		aux_goal,
		("Desbloqueado" if aux_done else "Bloqueado"),
	]
	inventory_list.add_child(aux_item)

	var sep_comp := HSeparator.new()
	inventory_list.add_child(sep_comp)

	var items_header := Label.new()
	items_header.text = "Itens"
	inventory_list.add_child(items_header)

	var kit_count := GameState.get_repair_kit_count()
	var kit_row := HBoxContainer.new()
	kit_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var kit_label := Label.new()
	kit_label.text = "Kit de reparacao: %d" % kit_count
	kit_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kit_row.add_child(kit_label)

	var use_button := Button.new()
	use_button.text = "Usar (+50% HP)"
	use_button.disabled = kit_count <= 0
	use_button.pressed.connect(_on_use_repair_kit_pressed)
	kit_row.add_child(use_button)
	inventory_list.add_child(kit_row)

	var sep_items := HSeparator.new()
	inventory_list.add_child(sep_items)

	var gadgets_header := Label.new()
	gadgets_header.text = "Gadgets (artefactos)"
	inventory_list.add_child(gadgets_header)

	# Outros artefactos (gadgets)
	for artifact_id_variant in ArtifactDatabase.ARTIFACTS.keys():
		var artifact_id := str(artifact_id_variant)
		if artifact_id == "aux_ship":
			continue
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
			"aux_ship":
				gadget_hint = "Gadget: nave auxiliar (auto-ataque)"
			"mining_drill":
				gadget_hint = "Gadget: broca para minerar ametista (E em cometas especiais)"
			"auto_regen":
				gadget_hint = "Gadget: regenera HP automaticamente fora de combate"

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
	if GameState.has_side_dash():
		var l3 := Label.new()
		l3.text = "- Dash Lateral (Mouse1/Mouse2)"
		inventory_list.add_child(l3)
		any_gadget = true
	if GameState.has_aux_ship():
		var l4 := Label.new()
		l4.text = "- Nave Auxiliar (auto-ataque)"
		inventory_list.add_child(l4)
		any_gadget = true
	if GameState.has_mining_drill():
		var l5 := Label.new()
		l5.text = "- Broca de Mineracao (minerar ametista com E)"
		inventory_list.add_child(l5)
		any_gadget = true
	if GameState.has_artifact("auto_regen"):
		var l6 := Label.new()
		l6.text = "- Regenerador (cura passiva com o tempo)"
		inventory_list.add_child(l6)
		any_gadget = true

	if not any_gadget:
		var none := Label.new()
		none.text = "Nenhum gadget desbloqueado ainda."
		inventory_list.add_child(none)

func _on_use_repair_kit_pressed() -> void:
	GameState.use_repair_kit()
	_update_hud()
	_rebuild_inventory_list()


func _rebuild_map_zone_list() -> void:
	if map_zone_list == null:
		return

	for child in map_zone_list.get_children():
		map_zone_list.remove_child(child)
		child.queue_free()

	# Verificar se há boss ativo
	var has_active_boss := _has_active_boss()
	
	# Atualizar mensagem de info
	if map_info_label != null:
		if has_active_boss:
			map_info_label.text = "Tens de derrotar o boss primeiro antes de trocar de zona."
		else:
			map_info_label.text = "(M) fecha"

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
		elif has_active_boss:
			# Se há boss ativo, desabilitar todas as zonas (exceto a atual)
			button.text = "%s  (Bloqueado: derrota o boss primeiro)" % title
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

		if can_access and not is_current and not has_active_boss:
			button.pressed.connect(_on_zone_selected.bind(zone_id))

		map_zone_list.add_child(button)

func _on_zone_selected(zone_id: String) -> void:
	# Verificar se há boss ativo antes de trocar de zona
	if _has_active_boss():
		return
	
	var manager := get_tree().get_first_node_in_group("zone_manager")
	if manager != null and manager.has_method("switch_to_zone"):
		manager.switch_to_zone(zone_id)
	_set_map_menu_visible(false)

func _has_active_boss() -> bool:
	# Verificar se há um boss ativo e engajado (lutando) no grupo "boss"
	var boss_nodes: Array[Node] = get_tree().get_nodes_in_group("boss")
	var player: Node2D = get_tree().get_first_node_in_group("player")
	if player == null:
		return false
	
	for boss in boss_nodes:
		if boss != null and is_instance_valid(boss):
			# Verificar se o boss está visível e ativo
			if boss is CanvasItem:
				var canvas_boss := boss as CanvasItem
				if not canvas_boss.visible:
					continue
				
				# Verificar se tem HP (se tiver o método/atributo)
				var hp_variant: Variant = boss.get("current_health")
				if hp_variant != null:
					var hp := int(hp_variant)
					if hp <= 0:
						continue
				
				# Verificar se o boss está engajado (lutando)
				if boss.has_method("is_boss_engaged"):
					if boss.is_boss_engaged():
						return true
				
				# Se não tem método is_boss_engaged, verificar distância ao jogador
				if boss is Node2D:
					var boss_2d := boss as Node2D
					var dist := boss_2d.global_position.distance_to(player.global_position)
					# Se o boss está perto (dentro de 1000 unidades), considera engajado
					if dist < 1000.0:
						return true
	return false
