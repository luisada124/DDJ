extends StaticBody2D

@export var speed: float = 40.0
@export var direction: Vector2 = Vector2.LEFT
@export var min_scrap: int = 1
@export var max_scrap: int = 3
@export var explosion_scene: PackedScene  # opcional: partículas/FX

func _ready() -> void:
	add_to_group("comet")

func _process(delta: float) -> void:
	position += direction * speed * delta

func explode() -> void:
	# FX opcional
	if explosion_scene != null:
		var fx = explosion_scene.instantiate()

		# 1) adicionar como filho do MESMO parent (nó "comets")
		var parent = get_parent()
		parent.add_child(fx)

		# 2) copiar posição/rotação/escala LOCAL
		fx.position = position
		fx.rotation = rotation
		fx.scale = scale

		# debug opcional
		print("Comet pos:", position, "  FX pos:", fx.position)

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
