extends Node2D

const EnemyScene: PackedScene = preload("res://enemies/Enemy.tscn")

@export var enabled: bool = true

# Se for 0, o valor é calculado automaticamente pela zona atual.
@export var max_guards: int = 0

@export var spawn_radius_min: float = 520.0
@export var spawn_radius_max: float = 760.0
@export var respawn_interval: float = 4.0

@export var station_safe_radius: float = 320.0
@export var chase_range_override: float = 1500.0
@export var guard_desired_distance: float = 420.0

var _guards: Array[Node] = []
var _timer: Timer

func _ready() -> void:
	if not enabled:
		return

	_timer = Timer.new()
	_timer.one_shot = false
	_timer.wait_time = respawn_interval
	_timer.autostart = true
	_timer.timeout.connect(_ensure_guards)
	add_child(_timer)

	call_deferred("_ensure_guards")

func _ensure_guards() -> void:
	if not enabled:
		return

	_guards = _guards.filter(func(n: Node) -> bool: return n != null and is_instance_valid(n))

	var desired := max_guards
	if desired <= 0:
		desired = _get_default_guard_count()

	while _guards.size() < desired:
		var e := _spawn_guard()
		if e == null:
			break
		_guards.append(e)

func _spawn_guard() -> Node:
	if EnemyScene == null:
		return null

	var station := get_parent()
	if station == null or not (station is Node2D):
		return null
	var station_node := station as Node2D

	var inst := EnemyScene.instantiate()
	if inst == null:
		return null
	if inst is Node2D:
		(inst as Node2D).global_position = _random_spawn_pos(station_node.global_position)

	var enemy_id := _pick_enemy_id()
	if inst.has_method("set"):
		inst.set("enemy_id", enemy_id)
		inst.set("difficulty_multiplier", 1.0)
		inst.set("desired_distance", guard_desired_distance)
		inst.set("chase_range", chase_range_override)

		# Ajuda o AI a respeitar a "bolha" da estação sem precisar de procurar pelo mapa todo.
		inst.set("home_station", station_node)
		inst.set("station_safe_radius", station_safe_radius)

	var root := get_tree().current_scene
	if root == null:
		return null
	root.add_child(inst)
	return inst

func _random_spawn_pos(center: Vector2) -> Vector2:
	var r := randf_range(spawn_radius_min, spawn_radius_max)
	var a := randf_range(0.0, TAU)
	return center + Vector2(cos(a), sin(a)) * r

func _get_default_guard_count() -> int:
	match GameState.current_zone_id:
		"inner":
			return 16
		"mid":
			return 14
		_:
			return 12

func _pick_enemy_id() -> String:
	match GameState.current_zone_id:
		"inner":
			return "tank" if randf() < 0.45 else "sniper"
		"mid":
			return "sniper" if randf() < 0.55 else "basic"
		_:
			return "basic"
