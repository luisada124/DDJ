extends StaticBody2D

const AMETISTA_TEXTURE: Texture2D = preload("res://textures/ametista-block.png")

@export var spawn_chance: float = 0.15
@export var mine_duration: float = 3.0
@export var yield_amount: int = 1

var _in_range: bool = false
var _mining: bool = false
var _progress: float = 0.0
var _depleted: bool = false
var _rng := RandomNumberGenerator.new()

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _prompt: Label = $Prompt
@onready var _range_area: Area2D = $RangeArea

func _ready() -> void:
	_rng.randomize()
	if _rng.randf() > spawn_chance:
		queue_free()
		return
	add_to_group("ametista_mine")
	if _sprite != null and AMETISTA_TEXTURE != null:
		_sprite.texture = AMETISTA_TEXTURE
	_update_prompt()

func _process(delta: float) -> void:
	if _depleted:
		return
	if not _in_range:
		if _mining:
			_cancel_mining()
		return
	if not GameState.has_artifact("mining_drill"):
		if _mining:
			_cancel_mining()
		_update_prompt()
		return

	var holding := Input.is_action_pressed("interact")
	if holding:
		_mining = true
		_progress += delta
		if _progress >= mine_duration:
			_finish_mining()
	else:
		if _mining:
			_cancel_mining()

	_update_prompt()

func _finish_mining() -> void:
	_depleted = true
	_mining = false
	_progress = mine_duration
	GameState.add_resource("ametista", yield_amount)
	if _sprite != null:
		_sprite.modulate = Color(0.6, 0.6, 0.6, 0.8)
	_update_prompt()

func _cancel_mining() -> void:
	_mining = false
	_progress = 0.0

func _update_prompt() -> void:
	if _prompt == null:
		return
	if not _in_range:
		_prompt.visible = false
		return

	_prompt.visible = true
	if _depleted:
		_prompt.text = "Ametista: esgotado"
		return

	if not GameState.has_artifact("mining_drill"):
		_prompt.text = "Precisas da Broca de Mineracao"
		return

	if _mining:
		_prompt.text = "Minerando... %.1fs / %.0fs (segura E)" % [_progress, mine_duration]
	else:
		_prompt.text = "E - Minerar Ametista (%.0fs)" % mine_duration

func _on_range_area_body_entered(body: Node2D) -> void:
	if body == null:
		return
	# Evita conflito com o EVA (E é usado para a corda).
	if body.is_in_group("ship"):
		_in_range = true
		_update_prompt()

func _on_range_area_body_exited(body: Node2D) -> void:
	if body == null:
		return
	if body.is_in_group("ship"):
		_in_range = false
		_cancel_mining()
		_update_prompt()
