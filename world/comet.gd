extends StaticBody2D

@export var speed: float = 40.0
@export var direction: Vector2 = Vector2.LEFT
@export var min_scrap: int = 1
@export var max_scrap: int = 3
@export var mineral_drop_chance: float = 0.15
@export var explosion_scene: PackedScene  # opcional: partículas/FX

@export var max_health: int = 30
var health: int

func _ready() -> void:
	add_to_group("comet")
	health = max_health

	# --- BONUS: apontar para o centro da câmara no spawn ---
	var camera := get_viewport().get_camera_2d()
	if camera != null:
		direction = (camera.global_position - global_position).normalized()
	# se camera for null, mantém a direction que já tinhas

func _process(delta: float) -> void:
	position += direction * speed * delta

func take_damage(amount: int) -> void:
	health -= amount
	print("Comet HP =", health)
	if health <= 0:
		explode()

func explode() -> void:
	if explosion_scene != null:
		var fx = explosion_scene.instantiate()
		get_tree().current_scene.add_child(fx)
		if fx is Node2D:
			(fx as Node2D).global_transform = global_transform

	_spawn_loot()
	queue_free()

func _spawn_loot() -> void:
	var pickup_scene: PackedScene = load("res://pickups/Pickup.tscn") # adapta o caminho

	var drops := randi_range(min_scrap, max_scrap)
	for i in range(drops):
		var loot = pickup_scene.instantiate()
		loot.global_position = global_position + Vector2(
			randf_range(-8.0, 8.0),
			randf_range(-8.0, 8.0)
		)
		if randf() < mineral_drop_chance:
			loot.set("resource_type", "mineral")
		else:
			loot.set("resource_type", "scrap")
		loot.set("amount", 1)
		get_tree().current_scene.add_child(loot)
