extends Area2D

@export var station_id: String = "station_alpha"
@export var prompt_text: String = "E - Estacao"
@export var planet_texture: Texture2D

var _player_in_range: bool = false

@onready var prompt: Label = $Prompt
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("trader")
	add_to_group("station")
	prompt.visible = false
	prompt.text = prompt_text
	if planet_texture != null:
		sprite.texture = planet_texture
	if not station_id.is_empty():
		prompt.text = StationCatalog.get_prompt(station_id)
		sprite.modulate = StationCatalog.get_station_color(station_id)

func is_player_in_range() -> bool:
	return _player_in_range

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	_player_in_range = true
	prompt.visible = true
	get_tree().call_group("hud", "register_station_in_range", self, station_id, true)
	get_tree().call_group("hud", "register_trader_in_range", self, true)

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	_player_in_range = false
	prompt.visible = false
	get_tree().call_group("hud", "register_station_in_range", self, station_id, false)
	get_tree().call_group("hud", "register_trader_in_range", self, false)
