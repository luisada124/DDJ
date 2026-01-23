extends Area2D

@export var resource_type: String = "scrap"
@export var amount: int = 1
@export var spin_speed: float = 2.0
@export var magnet_range: float = 140.0
@export var magnet_speed: float = 420.0
@export var despawn_seconds: float = 300.0
@export var despawn_scrap_only: bool = true

var _player: Node2D
var _default_texture: Texture2D
const AMETISTA_TEXTURE: Texture2D = preload("res://textures/ametista-block.png")
const SUCATA_TEXTURE: Texture2D = preload("res://textures/sucata.png")

func _ready() -> void:
	add_to_group("pickup")
	if has_node("Sprite2D"):
		_default_texture = ($Sprite2D as Sprite2D).texture
	_update_visuals()
	_start_despawn_timer()

func _process(delta: float) -> void:
	rotation += spin_speed * delta  # efeito a girar
	_magnet_to_player(delta)

func _update_visuals() -> void:
	if not has_node("Sprite2D"):
		return

	var sprite := $Sprite2D as Sprite2D
	sprite.texture = SUCATA_TEXTURE
	sprite.scale = Vector2(0.07, 0.07)
	sprite.modulate = Color(1, 1, 1)

	if resource_type == "mineral":
		sprite.texture = _default_texture
	elif resource_type == "ametista":
		sprite.texture = AMETISTA_TEXTURE
		sprite.modulate = Color(1, 1, 1)

func _magnet_to_player(delta: float) -> void:
	if magnet_range <= 0.0 or magnet_speed <= 0.0:
		return

	if _player == null or not is_instance_valid(_player) or not _player.is_in_group("player"):
		_player = get_tree().get_first_node_in_group("player") as Node2D
	if _player == null:
		return

	# No início, só o alien apanha recursos. A nave só apanha depois do artefacto "Aspirador".
	if _player.is_in_group("ship") and not GameState.can_ship_collect_pickups():
		return

	var effective_range := magnet_range * GameState.get_pickup_magnet_range_multiplier()
	var effective_speed := magnet_speed * GameState.get_pickup_magnet_speed_multiplier()
	if global_position.distance_to(_player.global_position) <= effective_range:
		global_position = global_position.move_toward(_player.global_position, effective_speed * delta)

func _on_body_entered(body: Node2D) -> void:  
	if body.is_in_group("alien"):
		GameState.add_resource(resource_type, amount)
		queue_free()
		return

	if body.is_in_group("ship") and GameState.can_ship_collect_pickups():
		GameState.record_vacuum_use()
		GameState.add_resource(resource_type, amount)
		queue_free()

func _start_despawn_timer() -> void:
	if despawn_seconds <= 0.0:
		return
	if despawn_scrap_only and resource_type != "scrap":
		return
	var timer := get_tree().create_timer(despawn_seconds)
	timer.timeout.connect(_on_despawn_timeout)

func _on_despawn_timeout() -> void:
	if is_inside_tree():
		queue_free()
