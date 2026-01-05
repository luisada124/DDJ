extends Node2D

const CometDatabase := preload("res://world/CometDatabase.gd")

@export var comet_scene: PackedScene

func _ready() -> void:
	randomize()

	# Se não definires no Inspector, carrega daqui
	if comet_scene == null:
		comet_scene = load("res://world/comet.tscn")

func _on_spawn_timer_timeout() -> void:
	if comet_scene == null:
		return

	var comet = comet_scene.instantiate()

	comet.set("comet_id", CometDatabase.get_random_id())

	# direção aleatória (com fallback)
	var dir := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if dir.length() < 0.2:
		dir = Vector2.LEFT
	comet.set("direction", dir.normalized())

	# posição aleatória (ajusta estes valores ao tamanho do teu nível)
	var x = randf_range(0.0, 1920.0)
	var y = randf_range(0.0, 1080.0)
	comet.position = Vector2(x, y)

	# adiciona o cometa como filho do nó "comets" da Zone1
	get_parent().get_node("comets").add_child(comet)
