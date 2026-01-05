extends Node2D

@export var comet_scene: PackedScene
@export var spawn_margin := 300   # distância fora do ecrã

func _ready() -> void:
	randomize()

	if comet_scene == null:
		comet_scene = load("res://world/comet.tscn")

func _on_spawn_timer_timeout() -> void:
	if comet_scene == null:
		return

	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return

	var comet = comet_scene.instantiate()

	# tamanho do ecrã em pixels
	var viewport_size = get_viewport().get_visible_rect().size

	# tamanho real no mundo (por causa do zoom)
	var zoom = camera.zoom
	var world_view_size = viewport_size / zoom

	# centro da câmara
	var cam_pos = camera.global_position

	# limites fora do ecrã
	var left   = cam_pos.x - world_view_size.x / 2 - spawn_margin
	var right  = cam_pos.x + world_view_size.x / 2 + spawn_margin
	var top    = cam_pos.y - world_view_size.y / 2 - spawn_margin
	var bottom = cam_pos.y + world_view_size.y / 2 + spawn_margin

	# escolher lado aleatório
	var side = randi() % 4
	var spawn_pos: Vector2

	match side:
		0: spawn_pos = Vector2(randf_range(left, right), top)       # cima
		1: spawn_pos = Vector2(randf_range(left, right), bottom)    # baixo
		2: spawn_pos = Vector2(left, randf_range(top, bottom))      # esquerda
		3: spawn_pos = Vector2(right, randf_range(top, bottom))     # direita

	comet.global_position = spawn_pos

	# adiciona no nó "comets"
	get_parent().get_node("comets").add_child(comet)
