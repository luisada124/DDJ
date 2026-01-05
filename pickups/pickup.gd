extends Area2D

@export var resource_type: String = "scrap"
@export var amount: int = 1
@export var spin_speed: float = 2.0
@export var magnet_range: float = 140.0
@export var magnet_speed: float = 420.0

var _player: Node2D

func _ready() -> void:
	add_to_group("pickup")

func _process(delta: float) -> void:
	rotation += spin_speed * delta  # efeito a girar
	_magnet_to_player(delta)

func _magnet_to_player(delta: float) -> void:
	if magnet_range <= 0.0 or magnet_speed <= 0.0:
		return

	if _player == null or not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player") as Node2D
		if _player == null:
			return

	if global_position.distance_to(_player.global_position) <= magnet_range:
		global_position = global_position.move_toward(_player.global_position, magnet_speed * delta)

func _on_body_entered(body: Node2D) -> void:  
	if body.is_in_group("player"):
		GameState.add_resource(resource_type, amount)
		queue_free()
