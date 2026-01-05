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
var _exploded: bool = false

func _ready() -> void:
	add_to_group("comet")
	_apply_comet_data()
	rotation = randf_range(0.0, TAU)
	health = max_health

	# add an Area2D detector to detect collisions with other comets
	if not has_node("Detector"):
		var detector := Area2D.new()
		detector.name = "Detector"
		# try to copy existing collision shape
		var cs = get_node_or_null("CollisionShape2D")
		if cs == null:
			cs = get_node_or_null("CollisionPolygon2D")
		if cs != null and cs is CollisionShape2D:
			var det_shape := CollisionShape2D.new()
			if cs.shape != null:
				det_shape.shape = cs.shape.duplicate()
			# copy transform (position/scale) so detector matches visual collider
			det_shape.position = cs.position
			det_shape.scale = cs.scale
			detector.add_child(det_shape)
		add_child(detector)
		# detector should detect bodies on the comet's collision layer
		detector.collision_layer = collision_layer
		detector.collision_mask = collision_layer
		detector.monitoring = true
		detector.connect("body_entered", Callable(self, "_on_detector_body_entered"))

	# --- BONUS: apontar para o centro da câmara no spawn ---
	var camera := get_viewport().get_camera_2d()
	if camera != null:
		direction = (camera.global_position - global_position).normalized()
	# se camera for null, mantém a direction que já tinhas

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
	if _exploded:
		return
	_exploded = true
	if explosion_scene != null:
		var fx = explosion_scene.instantiate()
		get_tree().current_scene.add_child(fx)
		if fx is Node2D:
			(fx as Node2D).global_position = global_position

	_spawn_loot()
	queue_free()

func _on_detector_body_entered(body: Node) -> void:
	if _exploded:
		return
	if body == self:
		return
	if body is Node and body.is_in_group("comet"):
		if body.has_method("explode"):
			body.explode()
		explode()

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
