extends Node2D

@export var enemy_scene: PackedScene
@export var enemies_container_path: NodePath = NodePath("../Enemies")

@export var enemy_scale: Vector2 = Vector2(0.4, 0.4)
@export var spawn_margin: float = 320.0
@export var min_spawn_distance_from_player: float = 420.0

@export var outer_spawn_interval: float = 3.0
@export var mid_spawn_interval: float = 2.0
@export var core_spawn_interval: float = 1.3

@export var outer_max_enemies: int = 4
@export var mid_max_enemies: int = 7
@export var core_max_enemies: int = 11

@onready var spawn_timer: Timer = $SpawnTimer

var _last_zone_id: String = ""

func _ready() -> void:
	randomize()

	if enemy_scene == null:
		enemy_scene = load("res://enemies/Enemy.tscn")

	_last_zone_id = GameState.current_zone_id
	GameState.state_changed.connect(_on_state_changed)
	_update_timer_wait_time()

func _on_state_changed() -> void:
	var zone_id := GameState.current_zone_id
	if zone_id != _last_zone_id:
		_last_zone_id = zone_id
		_clear_enemies()

	_update_timer_wait_time()

func _update_timer_wait_time() -> void:
	if spawn_timer == null:
		return
	spawn_timer.wait_time = _get_spawn_interval(GameState.current_zone_id)

func _on_spawn_timer_timeout() -> void:
	_spawn_enemy()
	_update_timer_wait_time()

func _spawn_enemy() -> void:
	var max_allowed := _get_max_enemies(GameState.current_zone_id)
	if _count_enemies() >= max_allowed:
		return

	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return

	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	if enemy_scene == null:
		return

	var enemy = enemy_scene.instantiate()
	if enemy == null:
		return

	enemy.set("difficulty_multiplier", _get_zone_difficulty(GameState.current_zone_id))
	enemy.set("enemy_id", _pick_enemy_id(GameState.current_zone_id))

	if enemy is Node2D:
		var enemy_2d := enemy as Node2D
		enemy_2d.scale = enemy_scale
		enemy_2d.global_position = _pick_spawn_position(camera, player.global_position)

	_get_container().add_child(enemy)

func _get_container() -> Node:
	if enemies_container_path != NodePath():
		var node := get_node_or_null(enemies_container_path)
		if node != null:
			return node
	return get_tree().current_scene

func _count_enemies() -> int:
	return get_tree().get_nodes_in_group("enemy").size()

func _clear_enemies() -> void:
	for node in get_tree().get_nodes_in_group("enemy"):
		if node is Node:
			(node as Node).queue_free()

func _get_spawn_interval(zone_id: String) -> float:
	match zone_id:
		"mid":
			return mid_spawn_interval
		"core":
			return core_spawn_interval
		_:
			return outer_spawn_interval

func _get_max_enemies(zone_id: String) -> int:
	match zone_id:
		"mid":
			return mid_max_enemies
		"core":
			return core_max_enemies
		_:
			return outer_max_enemies

func _pick_enemy_id(zone_id: String) -> String:
	var pool: Array[String]
	match zone_id:
		"mid":
			pool = ["basic", "sniper", "sniper", "sniper", "tank", "tank"]
		"core":
			pool = ["sniper", "sniper", "sniper", "tank", "tank", "tank", "tank"]
		_:
			pool = ["basic", "basic", "basic", "basic", "sniper"]

	return pool[randi_range(0, pool.size() - 1)]

func _get_zone_difficulty(zone_id: String) -> float:
	var def := ZoneCatalog.get_zone_def(zone_id)
	var mult := float(def.get("difficulty_multiplier", 1.0))
	return clamp(mult, 0.25, 10.0)

func _pick_spawn_position(camera: Camera2D, player_pos: Vector2) -> Vector2:
	var viewport_size := get_viewport().get_visible_rect().size
	var zoom := camera.zoom
	var world_view_size := viewport_size / zoom
	var cam_pos := camera.global_position

	var left := cam_pos.x - world_view_size.x / 2.0 - spawn_margin
	var right := cam_pos.x + world_view_size.x / 2.0 + spawn_margin
	var top := cam_pos.y - world_view_size.y / 2.0 - spawn_margin
	var bottom := cam_pos.y + world_view_size.y / 2.0 + spawn_margin

	for _i in range(8):
		var side := randi() % 4
		var spawn_pos: Vector2
		match side:
			0:
				spawn_pos = Vector2(randf_range(left, right), top) # cima
			1:
				spawn_pos = Vector2(randf_range(left, right), bottom) # baixo
			2:
				spawn_pos = Vector2(left, randf_range(top, bottom)) # esquerda
			_:
				spawn_pos = Vector2(right, randf_range(top, bottom)) # direita

		if spawn_pos.distance_to(player_pos) >= min_spawn_distance_from_player:
			return spawn_pos

	return Vector2(randf_range(left, right), top)
