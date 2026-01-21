extends CharacterBody2D

const SHIP_FORWARD := Vector2.UP   # ponta da nave na textura

const EnemyDatabase := preload("res://enemies/EnemyDatabase.gd")

const DEFAULT_STATION_SAFE_RADIUS := 320.0
const STATION_SAFE_MARGIN := 120.0

@export var enemy_id: String = "basic"
@export var difficulty_multiplier: float = 1.0

@export var move_speed: float = 250.0
@export var desired_distance: float = 300.0   # distância “ideal” ao player
@export var distance_tolerance: float = 20.0  # margem +/- antes de mexer
@export var chase_range: float = 2000.0
@export var detection_range: float = 0.0
@export var detection_mask: int = 3

@export var max_health: int = 30
@export var contact_damage: int = 10

@export var fire_interval: float = 1.2   # segundos entre tiros
@export var laser_damage: int = 5
@export var laser_scene: PackedScene     # Liga no Inspector a Laser.tscn

@export var pickup_scene: PackedScene
@export var min_drops: int = 1
@export var max_drops: int = 3
@export var mineral_drop_chance: float = 0.25
@export var ametista_drop_chance: float = 0.015
@export var scrap_amount: int = 1
@export var mineral_amount: int = 1

@export var patrol_radius: float = 650.0
@export var patrol_speed: float = 0.0
@export var patrol_pause_time: float = 0.6
@export var patrol_retarget_distance: float = 24.0
var enemy_data: EnemyData


var current_health: int
var player: CharacterBody2D
var fire_cooldown: float = 0.0

# Opcional: guardas de estação preenchem isto no spawn.
var home_station: Node2D = null
var station_safe_radius: float = 0.0
var _patrol_center: Vector2
var _patrol_target: Vector2
var _patrol_pause_timer: float = 0.0
var _tracking_player: bool = false
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	enemy_data = EnemyDatabase.get_data(enemy_id)   # <- buscar data
	EnemyDatabase.apply_to(self, enemy_id, difficulty_multiplier)          # <- aplicar stats

	_apply_texture()

	current_health = max_health
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	_rng.randomize()
	_patrol_center = global_position
	_pick_patrol_target()
	if detection_range <= 0.0:
		detection_range = chase_range
	if patrol_speed <= 0.0:
		patrol_speed = move_speed * 0.45


func _apply_texture() -> void:
	if not has_node("Sprite2D"):
		return
	if enemy_data == null:
		return

	var sprite := $Sprite2D as Sprite2D
	if enemy_data.texture != null:
		sprite.texture = enemy_data.texture

func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player) or not player.is_in_group("player"):
		player = get_tree().get_first_node_in_group("player") as CharacterBody2D

	var has_player := player != null
	var to_player := Vector2.ZERO
	var distance := INF
	var dir := Vector2.ZERO
	if has_player:
		to_player = player.global_position - global_position
		distance = to_player.length()
		if distance > 0.001:
			dir = to_player / distance

	var can_detect := has_player and _can_detect_player(distance)

	if can_detect:
		_tracking_player = true
		_handle_chase(distance, dir)
	else:
		# está numa boa distância -> paira
		velocity = Vector2.ZERO

		if _tracking_player:
			_tracking_player = false
			_patrol_center = global_position
			_patrol_pause_timer = patrol_pause_time
			_pick_patrol_target()
		_handle_patrol(delta)

	if has_player:
		_handle_shooting(delta, dir, can_detect, distance)

	# rodar a nave para apontar para o player
	rotation = dir.angle() - SHIP_FORWARD.angle()

	_apply_station_safe_radius()
	move_and_slide()

func _handle_shooting(delta: float, dir_to_player: Vector2, can_detect: bool, distance: float) -> void:
	# contar cooldown
	fire_cooldown -= delta
	if fire_cooldown > 0.0:
		return

	# so dispara se o player estiver relativamente perto
	if player == null or not can_detect:
		return

	if distance > chase_range:
		return

	_shoot(dir_to_player)
	fire_cooldown = fire_interval

func _handle_chase(distance: float, dir: Vector2) -> void:
	var min_dist := desired_distance - distance_tolerance
	var max_dist := desired_distance + distance_tolerance

	if distance < min_dist:
		velocity = -dir * move_speed
	elif distance > max_dist:
		velocity = dir * move_speed
	else:
		velocity = Vector2.ZERO

	if dir != Vector2.ZERO:
		rotation = dir.angle() - SHIP_FORWARD.angle()

func _handle_patrol(delta: float) -> void:
	if patrol_radius <= 0.0:
		velocity = Vector2.ZERO
		return

	if _patrol_pause_timer > 0.0:
		_patrol_pause_timer -= delta
		velocity = Vector2.ZERO
		return

	var to_target := _patrol_target - global_position
	if to_target.length() <= patrol_retarget_distance:
		_patrol_pause_timer = patrol_pause_time
		_pick_patrol_target()
		velocity = Vector2.ZERO
		return

	var dir := to_target.normalized()
	velocity = dir * patrol_speed
	if dir != Vector2.ZERO:
		rotation = dir.angle() - SHIP_FORWARD.angle()

func _pick_patrol_target() -> void:
	var angle := _rng.randf_range(0.0, TAU)
	var radius := _rng.randf_range(patrol_radius * 0.4, patrol_radius)
	_patrol_target = _patrol_center + Vector2(cos(angle), sin(angle)) * radius

func _can_detect_player(distance: float) -> bool:
	if player == null:
		return false
	if detection_range > 0.0 and distance > detection_range:
		return false

	var query := PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self]
	query.collision_mask = detection_mask
	query.collide_with_areas = false
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return false
	return hit.get("collider") == player


func _shoot(dir_to_player: Vector2) -> void:
	if laser_scene == null:
		laser_scene = load("res://player/lasers/Laser.tscn")

	var laser := laser_scene.instantiate()

	var spawn_offset := dir_to_player.normalized() * 40.0
	laser.global_position = global_position + spawn_offset

	laser.direction = dir_to_player.normalized()
	laser.rotation = dir_to_player.angle() - Vector2.UP.angle()

	laser.set("damage", laser_damage)
	laser.from_player = false   # <- MUITO IMPORTANTE

	get_tree().current_scene.add_child(laser)
	
	
func take_damage(amount: int) -> void:
	current_health -= amount

	if current_health <= 0:
		die()


func die() -> void:
	_spawn_loot()
	GameState.record_enemy_kill(enemy_id)
	queue_free()


func _spawn_loot() -> void:
	if pickup_scene == null:
		pickup_scene = load("res://pickups/Pickup.tscn") # adapta o caminho se for outro
	if pickup_scene == null:
		return

	var drops := randi_range(min_drops, max_drops)
	for i in range(drops):
		var loot = pickup_scene.instantiate()
		loot.global_position = global_position + Vector2(
			randf_range(-8.0, 8.0),
			randf_range(-8.0, 8.0)
		)
		if randf() < mineral_drop_chance:
			loot.set("resource_type", "mineral")
			loot.set("amount", mineral_amount)
		else:
			loot.set("resource_type", "scrap")
			loot.set("amount", scrap_amount)

		var in_zone2 := GameState.current_zone_id == "mid"
		if in_zone2 and randf() < ametista_drop_chance:
			loot.set("resource_type", "ametista")
			loot.set("amount", 1)
		get_tree().current_scene.add_child(loot)
