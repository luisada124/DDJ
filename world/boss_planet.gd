extends "res://world/trader_planet.gd"

@export var resources_path: NodePath = NodePath("BossResources")
@export var require_quest_active: bool = true
@export var use_pickup_rewards: bool = false

var _resources_root: Node = null
var _planet_active: bool = true
var _guard_spawner: Node = null

func _ready() -> void:
	super._ready()
	remove_from_group("station")
	_resources_root = get_node_or_null(resources_path)
	_guard_spawner = get_node_or_null("StationGuardSpawner")
	# Desabilitar spawner de guardas do planeta perdido
	if _guard_spawner != null:
		_guard_spawner.set("enabled", false)
		_guard_spawner.set("max_guards", 0)
		_guard_spawner.set("wave_total", 0)
		_guard_spawner.set_process(false)
		_guard_spawner.set_physics_process(false)
	_refresh_visibility()
	_refresh_resources()
	GameState.state_changed.connect(_on_state_changed)

func _on_state_changed() -> void:
	_refresh_visibility()
	_refresh_resources()

func _refresh_visibility() -> void:
	# Removido limitador - planeta sempre visível
	var should_show := true
	_set_planet_active(should_show)
	if should_show:
		_ensure_boss_completion_if_missing()

func _refresh_resources() -> void:
	if not use_pickup_rewards:
		_set_resources_active(false)
		return
	var unlocked := _planet_active and GameState.is_boss_defeated() and GameState.has_boss_planet_resources_unlocked()
	_set_resources_active(unlocked)

func _ensure_boss_completion_if_missing() -> void:
	if GameState.is_boss_defeated():
		return
	var boss := get_tree().get_first_node_in_group("boss")
	if boss == null or not is_instance_valid(boss):
		GameState.complete_quest(GameState.QUEST_BOSS_PLANET)

func _set_planet_active(active: bool) -> void:
	_planet_active = active
	visible = active
	set_process(active)
	set_physics_process(active)
	if self is Area2D:
		set_deferred("monitoring", active)
		set_deferred("monitorable", active)
	var prompt := get_node_or_null("Prompt") as Label
	if prompt != null:
		prompt.visible = active and _player_in_range
	# Guard spawner sempre desabilitado para o planeta perdido
	if _guard_spawner != null:
		_guard_spawner.set("enabled", false)
		_guard_spawner.set_process(false)
		_guard_spawner.set_physics_process(false)

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
		area.set_deferred("monitoring", active)
		area.set_deferred("monitorable", active)

func _is_blocked_by_guards() -> bool:
	# Planeta perdido nunca é bloqueado por guardas
	return false
