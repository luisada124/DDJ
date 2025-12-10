extends CharacterBody2D

@export var move_speed: float = 200.0
@export var stop_distance: float = 80.0
@export var max_health: int = 30
@export var contact_damage: int = 10

var current_health: int
var player: CharacterBody2D

func _ready() -> void:
	current_health = max_health
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	print("Enemy ready, player =", player)


func _physics_process(delta: float) -> void:
	# tentar encontrar o player se ainda não tivermos referência válida
	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as CharacterBody2D
		if player == null:
			return

	# vetor até ao player EM GLOBAL
	var to_player: Vector2 = player.global_position - global_position
	var distance := to_player.length()

	if distance > stop_distance:
		var dir := to_player.normalized()
		velocity = dir * move_speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if distance > 0.0:
		rotation = to_player.angle()


func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		die()


func die() -> void:
	_spawn_loot()
	queue_free()


func _spawn_loot() -> void:
	var pickup_scene: PackedScene = load("res://pickups/Pickup.tscn")
	var drops := randi_range(1, 3)
	for i in range(drops):
		var loot = pickup_scene.instantiate()
		loot.global_position = global_position + Vector2(
			randf_range(-8.0, 8.0),
			randf_range(-8.0, 8.0)
		)
		get_tree().current_scene.add_child(loot)
