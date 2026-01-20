extends Area2D

@export var station_id: String = "station"
@export var station_title: String = "Planeta - Estacao"
@export var prompt_text: String = "E - Estacao"
@export var tint: Color = Color(0.35, 0.7, 1, 1)

var _player_in_range: bool = false

@onready var prompt: Label = $Prompt

func _ready() -> void:
	add_to_group("trader")
	prompt.visible = false
	prompt.text = prompt_text

	if has_node("Sprite2D"):
		var sprite := $Sprite2D as Sprite2D
		sprite.modulate = tint

func get_station_id() -> String:
	return station_id

func get_station_title() -> String:
	return station_title

func is_player_in_range() -> bool:
	return _player_in_range

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	_player_in_range = true
	prompt.visible = true
	get_tree().call_group("hud", "register_trader_in_range", self, true)

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	_player_in_range = false
	prompt.visible = false
	get_tree().call_group("hud", "register_trader_in_range", self, false)
