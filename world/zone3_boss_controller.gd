extends Node2D

const BossScene: PackedScene = preload("res://enemies/BossFinal.tscn")

@export var spawn_delay: float = 15.0
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
	var root := get_tree().current_scene
	var zone_root := GameState.get_zone_root_node()
	if zone_root != null:
		root = zone_root
	if root == null:
		return

	var inst: Node = BossScene.instantiate()
	if not (inst is Node2D):
		return
	var boss := inst as Node2D
	boss.set_as_top_level(true)
	boss.global_position = boss_spawn_pos
	root.call_deferred("add_child", boss)
