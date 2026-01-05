extends StaticBody2D

@export var speed: float = 40.0
@export var direction: Vector2 = Vector2.LEFT
@export var min_scrap: int = 1
@export var max_scrap: int = 3
@export var explosion_scene: PackedScene  # opcional: partículas/FX

@export var max_health: int = 30
var health: int

func _ready() -> void:
	add_to_group("comet")
	health = max_health

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

	#if explosion_scene != null:
		#var fx = explosion_scene.instantiate()

		# 1) adicionar como filho do MESMO parent (nó "comets" dentro de Zone1)
		#var parent := get_parent()      # isto é o nó "comets"
		#parent.add_child(fx)

		# 2) usar posição GLOBAL para ficar certinho, mesmo com camera
		#fx.global_position = global_position
		#fx.global_rotation = global_rotation
		#fx.global_scale = global_scale

		#print("Comet GLOBAL:", global_position,
		#	  " | FX GLOBAL:", fx.global_position,
		#	  " | FX parent:", fx.get_parent().name)

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
		get_tree().current_scene.add_child(loot)
