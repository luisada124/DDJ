extends Control

@onready var continue_button: Button = $Content/MainRow/LeftPanel/PanelMargin/VBox/ButtonBox/ContinueButton
@onready var new_game_button: Button = $Content/MainRow/LeftPanel/PanelMargin/VBox/ButtonBox/NewGameButton
@onready var left_panel: PanelContainer = $Content/MainRow/LeftPanel
@onready var ricky_portrait: TextureRect = $Content/MainRow/Right/RickyPortrait
@onready var bg_far: TextureRect = $Backgrounds/StarfieldFar
@onready var bg_near: TextureRect = $Backgrounds/StarfieldNear

@export var far_scroll_speed: Vector2 = Vector2(0.006, 0.0)
@export var near_scroll_speed: Vector2 = Vector2(-0.014, 0.0)

var _far_offset: Vector2 = Vector2.ZERO
var _near_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	if continue_button != null:
		continue_button.pressed.connect(_on_continue_pressed)
	if new_game_button != null:
		new_game_button.pressed.connect(_on_new_game_pressed)
	_refresh_continue_state()
	_play_intro_animation()

func _refresh_continue_state() -> void:
	var has_save := FileAccess.file_exists(GameState.SAVE_PATH)
	if continue_button != null:
		continue_button.disabled = not has_save

func _on_continue_pressed() -> void:
	GameState.intro_pending = false
	get_tree().change_scene_to_file("res://world/Main.tscn")

func _on_new_game_pressed() -> void:
	GameState.reset_save()
	GameState.intro_pending = true
	get_tree().change_scene_to_file("res://world/Main.tscn")

func _process(delta: float) -> void:
	_scroll_backgrounds(delta)

func _scroll_backgrounds(delta: float) -> void:
	if bg_far != null:
		_far_offset += far_scroll_speed * delta
		_far_offset.x = fposmod(_far_offset.x, 1.0)
		_far_offset.y = fposmod(_far_offset.y, 1.0)
		var mat := bg_far.material
		if mat is ShaderMaterial:
			(mat as ShaderMaterial).set_shader_parameter("uv_offset", _far_offset)
	if bg_near != null:
		_near_offset += near_scroll_speed * delta
		_near_offset.x = fposmod(_near_offset.x, 1.0)
		_near_offset.y = fposmod(_near_offset.y, 1.0)
		var mat2 := bg_near.material
		if mat2 is ShaderMaterial:
			(mat2 as ShaderMaterial).set_shader_parameter("uv_offset", _near_offset)

func _play_intro_animation() -> void:
	if left_panel != null:
		left_panel.modulate.a = 0.0
	if ricky_portrait != null:
		ricky_portrait.modulate.a = 0.0
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	if left_panel != null:
		tween.tween_property(left_panel, "modulate:a", 1.0, 0.7)
	if ricky_portrait != null:
		tween.tween_property(ricky_portrait, "modulate:a", 1.0, 1.0).set_delay(0.15)
