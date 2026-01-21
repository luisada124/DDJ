extends "res://world/trader_planet.gd"

@export var resources_path: NodePath = NodePath("BossResources")

var _resources_root: Node = null

func _ready() -> void:
	super._ready()
	remove_from_group("station")
	_resources_root = get_node_or_null(resources_path)
	_refresh_resources()
	GameState.state_changed.connect(_on_state_changed)

func _on_state_changed() -> void:
	_refresh_resources()

func _refresh_resources() -> void:
	var unlocked := GameState.is_boss_defeated() and GameState.has_boss_planet_resources_unlocked()
	_set_resources_active(unlocked)

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
