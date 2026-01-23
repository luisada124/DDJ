extends Node2D

const BossScene: PackedScene = preload("res://enemies/BossFinal.tscn")

@export var spawn_delay: float = 10.0
@export var boss_spawn_pos: Vector2 = Vector2(0, 0)
@export var spawn_offscreen_margin: float = 140.0
@export var use_dynamic_spawn: bool = true

var _spawned: bool = false

func _ready() -> void:
	if GameState.current_zone_id != "core":
		return

	# Pequena introdução (deferred para garantir que player/hud já existem).
	call_deferred("_start_intro")

func _start_intro() -> void:
	var t0: SceneTreeTimer = get_tree().create_timer(0.15)
	await t0.timeout
	if not is_inside_tree():
		return
	if GameState.current_zone_id != "core":
		return

	GameState.emit_signal("speech_requested_timed", "Que lugar é este!..?", 4.5)

	# Delay antes do boss aparecer.
	call_deferred("_spawn_after_delay")

func _spawn_after_delay() -> void:
	var t: SceneTreeTimer = get_tree().create_timer(maxf(0.0, spawn_delay))
	await t.timeout
	if not is_inside_tree():
		return
	if GameState.current_zone_id != "core":
		return
	_spawn_boss()

func _spawn_boss() -> void:
	if _spawned:
		return
	
	# Verificar se o boss já foi morto
	var boss_id := "boss_core"
	if GameState.defeated_bosses.has(boss_id):
		return
	
	_spawned = true

	if BossScene == null:
		return
	var zone_root := GameState.get_zone_root_node()
	var root: Node = zone_root as Node if zone_root != null else get_tree().current_scene
	if root == null:
		return

	var inst: Node = BossScene.instantiate()
	if not (inst is Node2D):
		return
	var boss := inst as Node2D
	boss.set_as_top_level(true)
	boss.global_position = _get_boss_spawn_position()
	root.call_deferred("add_child", boss)

func _get_boss_spawn_position() -> Vector2:
	if not use_dynamic_spawn:
		return boss_spawn_pos

	var player := _get_player_node()
	if player == null:
		return boss_spawn_pos

	var view_half := _get_view_half_extents()
	var base_dist: float = maxf(view_half.x, view_half.y) + spawn_offscreen_margin
	if base_dist < 120.0:
		base_dist = 120.0

	var angle := randf_range(0.0, TAU)
	var dir := Vector2(cos(angle), sin(angle))
	return player.global_position + dir * base_dist

func _get_player_node() -> Node2D:
	var ship := get_tree().get_first_node_in_group("ship")
	if ship is Node2D:
		return ship as Node2D
	var player := get_tree().get_first_node_in_group("player")
	if player is Node2D:
		return player as Node2D
	return null

func _get_view_half_extents() -> Vector2:
	var cam: Camera2D = get_viewport().get_camera_2d()
	var vp_size: Vector2 = get_viewport().get_visible_rect().size
	if cam == null:
		return vp_size * 0.5
	var zoom := cam.zoom
	if zoom.x <= 0.0 or zoom.y <= 0.0:
		zoom = Vector2.ONE
	return Vector2(vp_size.x * 0.5 / zoom.x, vp_size.y * 0.5 / zoom.y)
