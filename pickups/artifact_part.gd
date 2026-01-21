extends Area2D

@export var spin_speed: float = 2.0
@export var keep_visible_when_completed: bool = false
@export var artifact_id: String = "relic"
@export var show_on_minimap: bool = true

const VACUUM_TEX: Texture2D = preload("res://textures/partes artefactos/aspirador.png")
const REVERSE_THRUSTER_TEX: Texture2D = preload("res://textures/partes artefactos/reverse_thruster.png")
const SIDE_DASH_TEX: Texture2D = preload("res://textures/partes artefactos/side.png")
const AUX_SHIP_TEX: Texture2D = preload("res://textures/partes artefactos/nane-aux.png")
const MINING_DRILL_TEX: Texture2D = preload("res://textures/partes artefactos/broca.png")
const AUTO_REGEN_TEX: Texture2D = preload("res://textures/partes artefactos/auto-regen.png")

func _ready() -> void:
	if show_on_minimap:
		add_to_group("artifact_part")
	_apply_part_texture()
	if GameState.is_artifact_completed(artifact_id) and not keep_visible_when_completed:
		queue_free()

func _process(delta: float) -> void:
	rotation += spin_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
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

	if tex != null:
		sprite.texture = tex
		sprite.modulate = Color(1, 1, 1, 1)
