extends "res://enemies/enemy.gd"

@export var artifact_scene: PackedScene
@export var artifact_id: String = "relic"
@export var patrol_anchor_path: NodePath
@export var require_quest_active: bool = true

var boss_engaged: bool = false
var _patrol_anchor: Node2D = null
var _boss_active: bool = true
var _initial_collision_layer: int = 0
var _initial_collision_mask: int = 0

func _ready() -> void:
	super._ready()
	add_to_group("boss")
	_initial_collision_layer = collision_layer
	_initial_collision_mask = collision_mask
	_set_patrol_anchor()
	_refresh_boss_active()
	GameState.state_changed.connect(_on_state_changed)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	boss_engaged = _tracking_player

func is_boss_engaged() -> bool:
	return boss_engaged

func _on_state_changed() -> void:
	_refresh_boss_active()

func _refresh_boss_active() -> void:
	var should_show := true
	if require_quest_active:
		should_show = GameState.has_boss_planet_marker()
	_set_boss_active(should_show)

func _set_boss_active(active: bool) -> void:
	_boss_active = active
	boss_engaged = false
	visible = active
	set_process(active)
	set_physics_process(active)
	if active:
		collision_layer = _initial_collision_layer
		collision_mask = _initial_collision_mask
	else:
		collision_layer = 0
		collision_mask = 0
		velocity = Vector2.ZERO

func _set_patrol_anchor() -> void:
	var anchor: Node2D = null
	if patrol_anchor_path != NodePath():
		anchor = get_node_or_null(patrol_anchor_path) as Node2D
	if anchor == null:
		var marker := get_tree().get_first_node_in_group("boss_planet_marker")
		if marker is Node2D:
			anchor = marker as Node2D
	if anchor != null:
		_patrol_anchor = anchor
		_patrol_center = _patrol_anchor.global_position
		_pick_patrol_target()

func die() -> void:
	_spawn_boss_artifact()
	super.die()
	GameState.complete_quest(GameState.QUEST_BOSS_PLANET)

func _spawn_boss_artifact() -> void:
	if artifact_scene == null:
		artifact_scene = load("res://pickups/ArtifactPart.tscn")
	if artifact_scene == null:
		return

	var part := artifact_scene.instantiate()
	part.global_position = global_position
	part.set("artifact_id", artifact_id)

	var root := get_tree().current_scene
	if root != null:
		root.call_deferred("add_child", part)

func _shoot(dir_to_player: Vector2) -> void:
	if laser_scene == null:
		laser_scene = load("res://player/lasers/Laser.tscn")
	if laser_scene == null:
		return

	var dir := dir_to_player.normalized()
	var perp := Vector2(-dir.y, dir.x)
	var offsets := [perp * 16.0, -perp * 16.0]
	for offset in offsets:
		var laser := laser_scene.instantiate()
		laser.global_position = global_position + dir * 40.0 + offset
		laser.direction = dir
		laser.rotation = dir.angle() - Vector2.UP.angle()
		laser.set("damage", laser_damage)
		laser.from_player = false

		var root := get_tree().current_scene
		if root != null:
			root.call_deferred("add_child", laser)
