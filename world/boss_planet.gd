extends "res://world/trader_planet.gd"

@export var resources_path: NodePath = NodePath("BossResources")
@export var require_quest_active: bool = true

var _resources_root: Node = null
var _planet_active: bool = true
var _guard_spawner: Node = null

func _ready() -> void:
	super._ready()
	remove_from_group("station")
	_resources_root = get_node_or_null(resources_path)
	_guard_spawner = get_node_or_null("StationGuardSpawner")
	_refresh_visibility()
	_refresh_resources()
	GameState.state_changed.connect(_on_state_changed)

func _on_state_changed() -> void:
	_refresh_visibility()
	_refresh_resources()

func _refresh_visibility() -> void:
	var should_show := true
	if require_quest_active:
		should_show = GameState.has_boss_planet_marker()
	_set_planet_active(should_show)

func _refresh_resources() -> void:
	var unlocked := _planet_active and GameState.is_boss_defeated() and GameState.has_boss_planet_resources_unlocked()
	_set_resources_active(unlocked)

func _set_planet_active(active: bool) -> void:
	_planet_active = active
	visible = active
	set_process(active)
	set_physics_process(active)
	if self is Area2D:
		monitoring = active
		monitorable = active
	var prompt := get_node_or_null("Prompt") as Label
	if prompt != null:
		prompt.visible = active and _player_in_range
	if _guard_spawner != null:
		_guard_spawner.set("enabled", active)
		_guard_spawner.set_process(active)
		_guard_spawner.set_physics_process(active)

func _set_resources_active(active: bool) -> void:
	if _resources_root == null:
		return
	for node in _resources_root.get_children():
		_set_resource_node_active(node, active)

func _set_resource_node_active(node: Node, active: bool) -> void:
	if node is CanvasItem:
		(node as CanvasItem).visible = active
	node.set_process(active)
	node.set_physics_process(active)
	if node is Area2D:
		var area := node as Area2D
		area.monitoring = active
		area.monitorable = active
