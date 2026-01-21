extends Node2D

const BossScene: PackedScene = preload("res://enemies/BossFinal.tscn")

@export var spawn_delay: float = 30.0
@export var boss_spawn_pos: Vector2 = Vector2(0, 0)

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

	var player_pos := _get_player_pos_or_center()
	GameState.speech_requested_at.emit("Que lugar é este!..?", player_pos)

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
	_spawned = true

	if BossScene == null:
		return
	var root := get_tree().current_scene
	if root == null:
		return

	var inst: Node = BossScene.instantiate()
	if not (inst is Node2D):
		return
	var boss := inst as Node2D
	boss.global_position = boss_spawn_pos
	root.add_child(boss)

func _get_player_pos_or_center() -> Vector2:
	var p := get_tree().get_first_node_in_group("player")
	if p is Node2D:
		return (p as Node2D).global_position
	return global_position
