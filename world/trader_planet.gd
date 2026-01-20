extends Area2D

@export var prompt_text: String = "E - Mercado"

var _player_in_range: bool = false

@onready var prompt: Label = $Prompt

func _ready() -> void:
	add_to_group("trader")
	prompt.visible = false
	prompt.text = prompt_text

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

