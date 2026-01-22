extends Node2D

const CometDatabase := preload("res://world/CometDatabase.gd")

@export var comet_scene: PackedScene
@export var spawn_margin: float = 320.0
@export var min_spawn_distance_from_player: float = 750.0
@export var spawn_attempts: int = 10

# Boost inicial (bom para o spawn do jogo). Mantem-se offscreen e respeita min distancia.
@export var initial_burst_count: int = 0
@export var initial_burst_delay: float = 0.8

var _did_initial_burst: bool = false

func _ready() -> void:
	randomize()
	if comet_scene == null:
		comet_scene = load("res://world/comet.tscn")
	if initial_burst_count > 0:
		call_deferred("_do_initial_burst")

func _on_spawn_timer_timeout() -> void:
	_spawn_one()

func _do_initial_burst() -> void:
	if _did_initial_burst:
		return
	_did_initial_burst = true
	if initial_burst_count <= 0:
		return

	var delay: float = maxf(0.0, initial_burst_delay)
	for _i in range(initial_burst_count):
		if not is_inside_tree():
			return
		_spawn_one()
		if delay > 0.0:
			await get_tree().create_timer(delay).timeout

func _spawn_one() -> void:
	if comet_scene == null:
		return

	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera == null:
		return

	var player := get_tree().get_first_node_in_group("player") as Node2D
	var player_pos: Vector2 = camera.global_position
	if player != null and is_instance_valid(player):
		player_pos = player.global_position

	var spawn_pos_variant: Variant = _pick_spawn_pos(camera, player_pos)
	if spawn_pos_variant == null:
		return
	var spawn_pos: Vector2 = spawn_pos_variant as Vector2

	var comet := comet_scene.instantiate()
	comet.set("comet_id", CometDatabase.get_random_id())

	var dir := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if dir.length() < 0.2:
		dir = Vector2.LEFT
	comet.set("direction", dir.normalized())

	comet.global_position = spawn_pos
	var comets := get_parent().get_node_or_null("comets")
	if comets != null:
		comets.add_child(comet)
	else:
		get_parent().add_child(comet)

func _pick_spawn_pos(camera: Camera2D, player_pos: Vector2) -> Variant:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var zoom: Vector2 = camera.zoom
	var world_view_size: Vector2 = viewport_size / zoom
	var cam_pos: Vector2 = camera.global_position

	var left: float = cam_pos.x - world_view_size.x / 2.0 - spawn_margin
	var right: float = cam_pos.x + world_view_size.x / 2.0 + spawn_margin
	var top: float = cam_pos.y - world_view_size.y / 2.0 - spawn_margin
	var bottom: float = cam_pos.y + world_view_size.y / 2.0 + spawn_margin

	var tries: int = maxi(1, spawn_attempts)
	for _i in range(tries):
		var side: int = randi() % 4
		var pos: Vector2
		match side:
			0:
				pos = Vector2(randf_range(left, right), top)
			1:
				pos = Vector2(randf_range(left, right), bottom)
			2:
				pos = Vector2(left, randf_range(top, bottom))
			_:
				pos = Vector2(right, randf_range(top, bottom))

		if pos.distance_to(player_pos) >= min_spawn_distance_from_player:
			return pos

	return null
