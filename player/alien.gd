extends CharacterBody2D

@export var swim_acceleration: float = 900.0
@export var max_speed: float = 420.0
@export var drag: float = 2.5

@export var tether_length: float = 260.0
@export var tether_min_length: float = 60.0
@export var tether_max_length: float = 1000.0
@export var tether_change_speed: float = 260.0

@export var tether_spring: float = 18.0
@export var tether_damping: float = 5.0

@onready var tether_line: Line2D = $TetherLine

var ship: Node2D = null

func setup(ship_node: Node2D) -> void:
	ship = ship_node

func _physics_process(delta: float) -> void:
	if ship == null or not is_instance_valid(ship):
		queue_free()
		return

	# controlar comprimento da corda
	if Input.is_action_pressed("rope_extend"):
		tether_length = min(tether_length + tether_change_speed * delta, tether_max_length)
	if Input.is_action_pressed("rope_retract"):
		tether_length = max(tether_length - tether_change_speed * delta, tether_min_length)

	# movimento "a nadar" no espaço (WASD)
	var input_vec: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_vec.length() > 0.001:
		velocity += input_vec.normalized() * swim_acceleration * delta

	# drag sempre (para não ficar infinito)
	velocity = velocity.lerp(Vector2.ZERO, drag * delta)

	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	# tether: puxa se esticar mais que o comprimento
	var to_ship: Vector2 = ship.global_position - global_position
	var dist: float = to_ship.length()
	if dist > 0.001:
		var dir: Vector2 = to_ship / dist
		if dist > tether_length:
			var stretch: float = dist - tether_length
			velocity += dir * stretch * tether_spring * delta

			# damping ao longo da corda para não oscilar demasiado
			var vel_along: float = velocity.dot(dir)
			velocity -= dir * vel_along * tether_damping * delta

	move_and_slide()

	_update_tether_line()

func _update_tether_line() -> void:
	if tether_line == null:
		return

	var points: PackedVector2Array = PackedVector2Array([
		ship.global_position,
		global_position,
	])
	tether_line.points = points
