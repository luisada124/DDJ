extends Node2D

@export var enemy_scene: PackedScene
@export var enemies_container_path: NodePath = NodePath("../Enemies")

@export var enemy_scale: Vector2 = Vector2(0.5, 0.5)
@export var spawn_margin: float = 320.0
@export var min_spawn_distance_from_player: float = 420.0

# Zona 1 (outer): evitar spawn "em cima" do jogador.
# Isto cria uma "zona preta" (quadrado) sem spawns à volta do player.
@export var outer_spawn_margin: float = 1200.0
@export var outer_no_spawn_square_half_size: float = 900.0

@export var outer_spawn_interval: float = 4.5
@export var mid_spawn_interval: float = 2.0
@export var core_spawn_interval: float = 1.3

# Zona 2 (mid): sistema de ondas
@export var mid_wave_interval_short: float = 30.0  # 30 segundos para 3 inimigos
@export var mid_wave_interval_long: float = 60.0   # 1 minuto para 5 inimigos
@export var mid_wave_count_short: int = 3
@export var mid_wave_count_long: int = 5

@export var outer_max_enemies: int = 3
@export var mid_max_enemies: int = 7
@export var core_max_enemies: int = 11

# Tempo sem spawns ao entrar na Zona 1 (outer), para dar "respiro" no início.
@export var outer_spawn_grace_seconds: float = 25.0

@onready var spawn_timer: Timer = $SpawnTimer

var _last_zone_id: String = ""
var _zone_time: float = 0.0
var _mid_wave_timer: float = 0.0
var _mid_wave_count: int = 0  # Contador de ondas para alternar entre curta e longa

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
		_zone_time = 0.0
		_mid_wave_timer = 0.0
		_mid_wave_count = 0
		_clear_enemies()

	_update_timer_wait_time()

func _process(delta: float) -> void:
	_zone_time += delta
	
	# Sistema de ondas para zona 2 (mid)
	if GameState.current_zone_id == "mid":
		_mid_wave_timer += delta
		var wave_interval: float
		var wave_count: int
		
		# Alternar entre onda curta (30s, 3 inimigos) e longa (60s, 5 inimigos)
		if _mid_wave_count % 2 == 0:
			wave_interval = mid_wave_interval_short
			wave_count = mid_wave_count_short
		else:
			wave_interval = mid_wave_interval_long
			wave_count = mid_wave_count_long
		
		if _mid_wave_timer >= wave_interval:
			_mid_wave_timer = 0.0
			_mid_wave_count += 1
			_spawn_mid_wave(wave_count)

func _update_timer_wait_time() -> void:
	if spawn_timer == null:
		return
	spawn_timer.wait_time = _get_spawn_interval(GameState.current_zone_id)

func _on_spawn_timer_timeout() -> void:
	# Zona 3 (core) é reservada para o boss final.
	if GameState.current_zone_id == "core":
		return
	# Zona 2 (mid) usa sistema de ondas, não spawn contínuo
	if GameState.current_zone_id == "mid":
		return
	if GameState.current_zone_id == "outer" and _zone_time < outer_spawn_grace_seconds:
		return
	_spawn_enemy()
	_update_timer_wait_time()

func _spawn_enemy() -> void:
	if GameState.current_zone_id == "core":
		return
	if GameState.current_zone_id == "outer" and _zone_time < outer_spawn_grace_seconds:
		return
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
		enemy_2d.global_position = _pick_spawn_position(camera, player.global_position, GameState.current_zone_id)

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
			return 0
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

func _pick_spawn_position(camera: Camera2D, player_pos: Vector2, zone_id: String) -> Vector2:
	var viewport_size := get_viewport().get_visible_rect().size
	var zoom := camera.zoom
	var world_view_size := viewport_size / zoom
	var cam_pos := camera.global_position

	var margin := spawn_margin
	if zone_id == "outer":
		margin = outer_spawn_margin

	var left := cam_pos.x - world_view_size.x / 2.0 - margin
	var right := cam_pos.x + world_view_size.x / 2.0 + margin
	var top := cam_pos.y - world_view_size.y / 2.0 - margin
	var bottom := cam_pos.y + world_view_size.y / 2.0 + margin

	var best: Vector2 = Vector2(randf_range(left, right), top)
	var best_score: float = -INF
	var tries: int = 22 if zone_id == "outer" else 8

	for _i in range(tries):
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

		# Zona preta (quadrado) em torno do jogador, sem spawns (Zona 1).
		if zone_id == "outer":
			var dx := absf(spawn_pos.x - player_pos.x)
			var dy := absf(spawn_pos.y - player_pos.y)
			if dx <= outer_no_spawn_square_half_size and dy <= outer_no_spawn_square_half_size:
				continue

		# Score: o mais longe possível do jogador (reduz spawns "ao lado" da nave).
		var score := spawn_pos.distance_to(player_pos)
		if score > best_score:
			best_score = score
			best = spawn_pos

		# Para zonas não-outer, basta respeitar a distância mínima e sair cedo.
		if zone_id != "outer" and score >= min_spawn_distance_from_player:
			return spawn_pos

	return best

func _spawn_mid_wave(count: int) -> void:
	# Spawnar uma onda de inimigos na zona 2, fora da visão do jogador
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return
	
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	if enemy_scene == null:
		return
	
	var viewport_size := get_viewport().get_visible_rect().size
	var zoom := camera.zoom
	var world_view_size := viewport_size / zoom
	var cam_pos := camera.global_position
	var player_pos := player.global_position
	
	# Calcular área fora da visão (fora da tela)
	var spawn_margin: float = 200.0  # Margem para garantir que spawna fora da tela
	var left := cam_pos.x - world_view_size.x / 2.0 - spawn_margin
	var right := cam_pos.x + world_view_size.x / 2.0 + spawn_margin
	var top := cam_pos.y - world_view_size.y / 2.0 - spawn_margin
	var bottom := cam_pos.y + world_view_size.y / 2.0 + spawn_margin
	
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(count):
		var enemy = enemy_scene.instantiate()
		if enemy == null:
			continue
		
		enemy.set("difficulty_multiplier", _get_zone_difficulty("mid"))
		enemy.set("enemy_id", _pick_enemy_id("mid"))
		
		if enemy is Node2D:
			var enemy_2d := enemy as Node2D
			enemy_2d.scale = enemy_scale
			
			# Escolher um lado aleatório (top, bottom, left, right) para spawnar
			var side := rng.randi_range(0, 3)
			var spawn_pos: Vector2
			match side:
				0:  # Topo
					spawn_pos = Vector2(rng.randf_range(left, right), top)
				1:  # Fundo
					spawn_pos = Vector2(rng.randf_range(left, right), bottom)
				2:  # Esquerda
					spawn_pos = Vector2(left, rng.randf_range(top, bottom))
				_:  # Direita
					spawn_pos = Vector2(right, rng.randf_range(top, bottom))
			
			enemy_2d.global_position = spawn_pos
			_get_container().add_child(enemy)
