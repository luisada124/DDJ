extends Area2D

@export var resource_type: String = "scrap"
@export var amount: int = 1
@export var spin_speed: float = 2.0
@export var magnet_range: float = 140.0
@export var magnet_speed: float = 420.0

var _player: Node2D

func _ready() -> void:
	add_to_group("pickup")
	_update_visuals()

func _process(delta: float) -> void:
	rotation += spin_speed * delta  # efeito a girar
	_magnet_to_player(delta)

func _update_visuals() -> void:
	if not has_node("Sprite2D"):
		return

	var sprite := $Sprite2D as Sprite2D
	if resource_type == "mineral":
		sprite.modulate = Color(0.45, 0.85, 1.0)
	else:
		sprite.modulate = Color(1, 1, 1)

func _magnet_to_player(delta: float) -> void:
	if magnet_range <= 0.0 or magnet_speed <= 0.0:
		return

	if _player == null or not is_instance_valid(_player) or not _player.is_in_group("player"):
		_player = get_tree().get_first_node_in_group("player") as Node2D
	if _player == null:
		return

	var effective_range := magnet_range * GameState.get_pickup_magnet_range_multiplier()
	var effective_speed := magnet_speed * GameState.get_pickup_magnet_speed_multiplier()
	if global_position.distance_to(_player.global_position) <= effective_range:
		global_position = global_position.move_toward(_player.global_position, effective_speed * delta)

func _on_body_entered(body: Node2D) -> void:  
	if body.is_in_group("player"):
		GameState.add_resource(resource_type, amount)
		queue_free()
