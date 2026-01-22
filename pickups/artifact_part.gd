extends Area2D

@export var spin_speed: float = 2.0
@export var keep_visible_when_completed: bool = false
@export var artifact_id: String = "relic"
@export var show_on_minimap: bool = true
@export var require_interact: bool = true
@export var prompt_text: String = "E - Apanhar"

const VACUUM_TEX: Texture2D = preload("res://textures/partes artefactos/aspirador.png")
const REVERSE_THRUSTER_TEX: Texture2D = preload("res://textures/partes artefactos/reverse_thruster.png")
const SIDE_DASH_TEX: Texture2D = preload("res://textures/partes artefactos/side.png")
const AUX_SHIP_TEX: Texture2D = preload("res://textures/partes artefactos/nane-aux.png")
const MINING_DRILL_TEX: Texture2D = preload("res://textures/partes artefactos/broca.png")
const AUTO_REGEN_TEX: Texture2D = preload("res://textures/partes artefactos/auto-regen.png")
const RELIC_TEX: Texture2D = preload("res://textures/Crystal_01.png")

var _player_in_range: bool = false
var _collector: Node2D = null

func _ready() -> void:
	if show_on_minimap:
		add_to_group("artifact_part")
	_apply_part_texture()
	_update_prompt()
	if GameState.is_artifact_completed(artifact_id) and not keep_visible_when_completed:
		queue_free()

func _process(delta: float) -> void:
	rotation += spin_speed * delta
	if require_interact and _player_in_range and Input.is_action_just_pressed("interact"):
		if _collector != null and is_instance_valid(_collector):
			_collect(_collector)

func _on_body_entered(body: Node2D) -> void:
	if body != null and body.is_in_group("alien"):
		if require_interact:
			_player_in_range = true
			_collector = body
			_update_prompt()
			return
		_collect(body)

func _on_body_exited(body: Node2D) -> void:
	if body != null and body.is_in_group("alien"):
		_player_in_range = false
		if _collector == body:
			_collector = null
		_update_prompt()

func _collect(player: Node2D) -> void:
	_on_collected(player)

func _on_collected(_player: Node2D) -> void:
	GameState.collect_artifact_part(artifact_id)
	queue_free()

func _apply_part_texture() -> void:
	if not has_node("Sprite2D"):
		return
	var sprite := $Sprite2D as Sprite2D
	var tex: Texture2D = null
	match artifact_id:
		"vacuum":
			tex = VACUUM_TEX
		"reverse_thruster":
			tex = REVERSE_THRUSTER_TEX
		"side_dash":
			tex = SIDE_DASH_TEX
		"aux_ship":
			tex = AUX_SHIP_TEX
		"mining_drill":
			tex = MINING_DRILL_TEX
		"auto_regen":
			tex = AUTO_REGEN_TEX
		"relic":
			tex = RELIC_TEX

	if tex != null:
		sprite.texture = tex
		sprite.modulate = Color(1, 1, 1, 1)

func _update_prompt() -> void:
	if not has_node("Prompt"):
		return
	var label := $Prompt as Label
	label.text = prompt_text
	label.visible = require_interact and _player_in_range
