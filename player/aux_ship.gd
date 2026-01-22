extends Area2D

const LaserScene: PackedScene = preload("res://player/lasers/Laser.tscn")
const AUX_TEXTURE: Texture2D = preload("res://textures/nave-gadget-removebg-preview.png")

@export var follow_offset: Vector2 = Vector2(120, 80)
@export var follow_lerp: float = 8.0
@export var orbit_radius: float = 30.0
@export var orbit_speed: float = 1.2
@export var impact_push_distance: float = 120.0
@export var impact_cooldown_time: float = 0.25

@export var acquire_interval: float = 0.25

var _follow_target: Node2D = null
var _target: Node2D = null
var _fire_cooldown: float = 0.0
var _acquire_cooldown: float = 0.0
var _t: float = 0.0
var _impact_cooldown: float = 0.0

@onready var _sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("aux_ship")
	if _sprite != null and AUX_TEXTURE != null:
		_sprite.texture = AUX_TEXTURE

func _process(delta: float) -> void:
	if not GameState.has_artifact("aux_ship"):
		queue_free()
		return

	_t += delta
	_fire_cooldown = maxf(0.0, _fire_cooldown - delta)
	_acquire_cooldown = maxf(0.0, _acquire_cooldown - delta)
	_impact_cooldown = maxf(0.0, _impact_cooldown - delta)

	_ensure_follow_target()
	if _follow_target == null:
		return

	_update_follow(delta)
	_update_targeting()

func _ensure_follow_target() -> void:
	if _follow_target != null and is_instance_valid(_follow_target):
		return
	_follow_target = get_tree().get_first_node_in_group("player") as Node2D

func _update_follow(delta: float) -> void:
	var orbit := Vector2(cos(_t * orbit_speed), sin(_t * orbit_speed)) * orbit_radius
	var desired := _follow_target.global_position + follow_offset + orbit
	var w: float = minf(1.0, follow_lerp * delta)
	global_position = global_position.lerp(desired, w)

func _update_targeting() -> void:
	if _acquire_cooldown <= 0.0:
		_acquire_cooldown = acquire_interval
		_target = _pick_target()

	if _target == null:
		return

	var to_target := _target.global_position - global_position
	if to_target.length() <= 0.001:
		return

	var dir := to_target.normalized()
	rotation = dir.angle() - Vector2.UP.angle()

	if _fire_cooldown > 0.0:
		return

	_fire(dir)
	_fire_cooldown = GameState.get_aux_ship_fire_interval()

func _pick_target() -> Node2D:
	var max_range: float = GameState.get_aux_ship_range()
	var best: Node2D = null
	var best_d := max_range

	for n in get_tree().get_nodes_in_group("enemy"):
		if n == null or not is_instance_valid(n):
			continue
		if not (n is Node2D):
			continue
		var e := n as Node2D
		var d := (e.global_position - global_position).length()
		if d < best_d:
			best_d = d
			best = e

	return best

func _fire(dir: Vector2) -> void:
	if LaserScene == null:
		return

	var laser: Area2D = LaserScene.instantiate() as Area2D
	if laser == null:
		return

	laser.set("from_player", true)
	laser.set("direction", dir)
	laser.rotation = dir.angle() - Vector2.UP.angle()
	laser.set("damage", GameState.get_aux_ship_laser_damage())
	laser.set("speed", GameState.get_aux_ship_laser_speed())

	var inherited := Vector2.ZERO
	if _follow_target != null and is_instance_valid(_follow_target):
		var v: Variant = _follow_target.get("velocity")
		if typeof(v) == TYPE_VECTOR2:
			inherited = v as Vector2
	laser.set("inherited_velocity", inherited)

	laser.global_position = global_position + dir * 40.0
	var root: Node = get_tree().current_scene
	if root != null:
		root.call_deferred("add_child", laser)

func _on_body_entered(body: Node2D) -> void:
	if body == null or not is_instance_valid(body):
		return
	if _impact_cooldown > 0.0:
		return

	# Só reage a coisas "grandes" do jogo.
	if not (body.is_in_group("comet") or body.is_in_group("enemy")):
		return

	var away := global_position - body.global_position
	if away.length() <= 0.001:
		away = Vector2.RIGHT.rotated(randf_range(0.0, TAU))
	else:
		away = away.normalized()

	global_position += away * impact_push_distance
	_target = null
	_impact_cooldown = impact_cooldown_time
