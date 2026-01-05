extends CharacterBody2D

const SHIP_FORWARD := Vector2.UP   # ponta da nave na textura

const EnemyDatabase := preload("res://enemies/EnemyDatabase.gd")

@export var enemy_id: String = "basic"
@export var difficulty_multiplier: float = 1.0

@export var move_speed: float = 250.0
@export var desired_distance: float = 300.0   # distância “ideal” ao player
@export var distance_tolerance: float = 20.0  # margem +/- antes de mexer
@export var chase_range: float = 2000.0

@export var max_health: int = 30
@export var contact_damage: int = 10

@export var fire_interval: float = 1.2   # segundos entre tiros
@export var laser_damage: int = 5
@export var laser_scene: PackedScene     # Liga no Inspector a Laser.tscn

@export var pickup_scene: PackedScene
@export var min_drops: int = 1
@export var max_drops: int = 3
@export var mineral_drop_chance: float = 0.25
@export var scrap_amount: int = 1
@export var mineral_amount: int = 1

var current_health: int
var player: CharacterBody2D
var fire_cooldown: float = 0.0


func _ready() -> void:
	EnemyDatabase.apply_to(self, enemy_id, difficulty_multiplier)
	current_health = max_health
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	print("Enemy READY, player =", player)
	_apply_debug_color()

func _apply_debug_color() -> void:
	if not has_node("Sprite2D"):
		return

	var sprite := $Sprite2D as Sprite2D
	match enemy_id:
		"sniper":
			sprite.modulate = Color(0.5, 0.95, 1.0) # azul
		"tank":
			sprite.modulate = Color(1.0, 0.6, 0.35) # laranja
		_:
			sprite.modulate = Color(1, 1, 1)


func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player) or not player.is_in_group("player"):
		player = get_tree().get_first_node_in_group("player") as CharacterBody2D
		if player == null:
			return

	var to_player: Vector2 = player.global_position - global_position
	var distance := to_player.length()

	# fora do radar -> não faz nada
	if distance > chase_range:
		velocity = Vector2.ZERO
		return

	var dir := to_player.normalized()

	# Mantém uma órbita: se está muito longe, aproxima; se está muito perto, afasta
	var min_dist := desired_distance - distance_tolerance
	var max_dist := desired_distance + distance_tolerance

	if distance < min_dist:
		# muito perto -> afastar
		velocity = -dir * move_speed
	elif distance > max_dist:
		# muito longe -> aproximar
		velocity = dir * move_speed
	else:
		# está numa boa distância -> paira
		velocity = Vector2.ZERO

	# rodar a nave para apontar para o player
	rotation = dir.angle() - SHIP_FORWARD.angle()

	move_and_slide()

	# disparar se dentro do chase_range
	_handle_shooting(delta, dir)
	
func _handle_shooting(delta: float, dir_to_player: Vector2) -> void:
	# contar cooldown
	fire_cooldown -= delta
	if fire_cooldown > 0.0:
		return

	# só dispara se o player estiver relativamente perto
	if player == null:
		return

	var distance := (player.global_position - global_position).length()
	if distance > chase_range:
		return

	_shoot(dir_to_player)
	fire_cooldown = fire_interval


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
	print("Enemy took damage:", amount, " | HP agora =", current_health)

	if current_health <= 0:
		die()


func die() -> void:
	print("Enemy morreu!")
	_spawn_loot()
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
		get_tree().current_scene.add_child(loot)
