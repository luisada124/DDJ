extends CharacterBody2D

@export var swim_acceleration: float = 650.0
@export var max_speed: float = 280.0
@export var drag: float = 3.2

@export var tether_length: float = 260.0
@export var tether_min_length: float = 60.0
@export var tether_max_length: float = 1000.0
@export var tether_change_speed: float = 260.0
@export var tether_winch_acceleration: float = 700.0

@export var tether_spring: float = 18.0
@export var tether_damping: float = 5.0

@onready var tether_line: Line2D = $TetherLine
@onready var rope_anchor: Node2D = get_node_or_null("RopeAnchor") as Node2D

var ship: Node2D = null
var ship_rope_anchor: Node2D = null

func setup(ship_node: Node2D) -> void:
	ship = ship_node
	ship_rope_anchor = ship.get_node_or_null("RopeAnchor") as Node2D

func take_damage(amount: int) -> void:
	GameState.damage_alien(amount)
	if GameState.alien_health <= 0:
		queue_free()

func _physics_process(delta: float) -> void:
	if ship == null or not is_instance_valid(ship):
		queue_free()
		return

	# controlar comprimento da corda
	var retracting: bool = Input.is_action_pressed("rope_retract")
	var extending: bool = Input.is_action_pressed("rope_extend")

	if extending:
		tether_length += tether_change_speed * delta
		if tether_length > tether_max_length:
			tether_length = tether_max_length
	if retracting:
		tether_length -= tether_change_speed * delta
		if tether_length < tether_min_length:
			tether_length = tether_min_length

	# movimento "a nadar" no espaço (WASD)
	var input_vec: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_vec.length() > 0.001:
		velocity += input_vec.normalized() * swim_acceleration * delta

	# drag sempre (para não ficar infinito)
	velocity = velocity.lerp(Vector2.ZERO, drag * delta)

	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	# tether: puxa se esticar mais que o comprimento
	var ship_anchor_pos: Vector2 = ship.global_position
	if ship_rope_anchor != null and is_instance_valid(ship_rope_anchor):
		ship_anchor_pos = ship_rope_anchor.global_position

	var alien_anchor_pos: Vector2 = global_position
	if rope_anchor != null and is_instance_valid(rope_anchor):
		alien_anchor_pos = rope_anchor.global_position

	var to_ship: Vector2 = ship_anchor_pos - alien_anchor_pos
	var dist: float = to_ship.length()
	if dist > 0.001:
		var dir: Vector2 = to_ship / dist
		if retracting:
			velocity += dir * tether_winch_acceleration * delta
		if dist > tether_length:
			var stretch: float = dist - tether_length
			velocity += dir * stretch * tether_spring * delta

			# damping ao longo da corda para não oscilar demasiado
			var vel_along: float = velocity.dot(dir)
			velocity -= dir * vel_along * tether_damping * delta

	move_and_slide()

	_update_tether_line(ship_anchor_pos, alien_anchor_pos, dist)

func _update_tether_line(ship_anchor_pos: Vector2, alien_anchor_pos: Vector2, distance: float) -> void:
	if tether_line == null:
		return

	if distance > tether_length:
		tether_line.default_color = Color(0.9, 0.9, 1.0, 0.9)
	else:
		tether_line.default_color = Color(0.65, 0.65, 0.9, 0.55)

	var points: PackedVector2Array = PackedVector2Array([
		ship_anchor_pos,
		alien_anchor_pos,
	])
	tether_line.points = points
