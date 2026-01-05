extends StaticBody2D

const CometDatabase := preload("res://world/CometDatabase.gd")

@export var comet_id: String = "meteor_01"
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
	_apply_comet_data()
	rotation = randf_range(0.0, TAU)
	health = max_health

func _apply_comet_data() -> void:
	var data := CometDatabase.get_data(comet_id)
	if data == null:
		return

	speed = data.speed
	max_health = data.max_health
	min_scrap = data.min_scrap
	max_scrap = data.max_scrap
	mineral_drop_chance = data.mineral_drop_chance

	if has_node("comet"):
		var sprite := $comet as Sprite2D
		var tex = load(data.texture_path)
		if tex is Texture2D:
			sprite.texture = tex
		sprite.scale = data.sprite_scale

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
			(fx as Node2D).global_position = global_position

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
		if randf() < mineral_drop_chance:
			loot.set("resource_type", "mineral")
		else:
			loot.set("resource_type", "scrap")
		loot.set("amount", 1)
		get_tree().current_scene.add_child(loot)
