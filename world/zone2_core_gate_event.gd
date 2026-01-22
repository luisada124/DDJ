extends Node2D

const EnemyScene: PackedScene = preload("res://enemies/Enemy.tscn")
const RelicScene: PackedScene = preload("res://pickups/ArtifactPart.tscn")

@export var patrol_basic_count: int = 10
@export var patrol_sniper_count: int = 6
@export var patrol_tank_count: int = 3
@export var patrol_spawn_radius: float = 1600.0
@export var patrol_spawn_jitter: float = 220.0
@export var patrol_difficulty_multiplier: float = 1.6
@export var patrol_enemy_scale: Vector2 = Vector2(0.5, 0.5)

# Espera os 2 baloes (4.5s cada no HUD) + margem.
@export var patrol_spawn_delay: float = 9.2

@export var speaker_enemy_id: String = "basic"
@export var speaker_difficulty_multiplier: float = 1.0
@export var speaker_scale: Vector2 = Vector2(0.6, 0.6)
@export var speaker_spawn_distance: float = 780.0

@export var leader_enemy_id: String = "tank"
@export var leader_difficulty_multiplier: float = 2.4
@export var leader_scale: Vector2 = Vector2(0.95, 0.95)
@export var leader_spawn_distance: float = 900.0
@export var leader_tint: Color = Color(1.0, 0.15, 0.15, 1.0)

var _active: bool = false
var _last_enemy_pos: Vector2 = Vector2.ZERO
var _speaker: Node2D = null
var _leader: Node2D = null
var _leader_last_hp: int = 999999
var _leader_last_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	if GameState.current_zone_id != "mid":
		return

	GameState.zone2_core_horde_requested.connect(_on_horde_requested)

	# Se já limpou a patrulha e ainda não tem a 2ª relíquia, respawna o drop.
	if GameState.mid_core_patrol_cleared and GameState.artifact_parts_collected < ZoneCatalog.get_required_artifact_parts("core"):
		_spawn_relic(_get_player_pos_or_center())
		return

	# Se o evento já foi iniciado mas não foi concluído (ex: saiu da zona), reinicia a patrulha.
	if GameState.mid_core_event_triggered and not GameState.mid_core_patrol_cleared and GameState.artifact_parts_collected < ZoneCatalog.get_required_artifact_parts("core"):
		call_deferred("_start_event")

func _on_horde_requested() -> void:
	# Pedido vindo do diálogo (Posto Kappa).
	if GameState.current_zone_id != "mid":
		return
	if GameState.mid_core_patrol_cleared:
		return
	if _active:
		return
	_start_event()

func _process(_delta: float) -> void:
	if _leader != null and is_instance_valid(_leader):
		_leader_last_pos = _leader.global_position
		var hp_variant: Variant = _leader.get("current_health")
		if hp_variant != null:
			_leader_last_hp = int(hp_variant)

	if _active:
		return
	if GameState.current_zone_id != "mid":
		return
	if GameState.mid_core_patrol_cleared:
		return

	var required_core: int = ZoneCatalog.get_required_artifact_parts("core")
	if GameState.artifact_parts_collected >= required_core:
		return

	# Condição: todos os gadgets + media dos upgrades >= 8.
	return

func _start_event() -> void:
	if _active:
		return
	_active = true

	var speaker_pos := _pick_speaker_enemy_pos()
	_spawn_speaker()
	if _speaker != null and is_instance_valid(_speaker):
		speaker_pos = _speaker.global_position
	GameState.emit_signal("speech_requested_at", "Temos de dizimar!", speaker_pos)
	GameState.emit_signal("speech_requested_at", "A chamar reforços.", speaker_pos)

	call_deferred("_spawn_patrol_after_delay")

func _pick_speaker_enemy_pos() -> Vector2:
	var player_pos := _get_player_pos_or_center()
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	var best: Node2D = null
	var best_dist: float = INF
	for n in enemies:
		if n is Node2D:
			var e := n as Node2D
			var d := e.global_position.distance_to(player_pos)
			if d < best_dist:
				best_dist = d
				best = e
	if best != null:
		return best.global_position
	return player_pos + Vector2(500, -260)

func _spawn_patrol_after_delay() -> void:
	var delay: float = maxf(0.0, patrol_spawn_delay)
	var t: SceneTreeTimer = get_tree().create_timer(delay)
	await t.timeout
	if not is_inside_tree():
		return
	if GameState.current_zone_id != "mid":
		return
	if GameState.mid_core_patrol_cleared:
		return
	_spawn_leader()
	_spawn_patrol()

func _spawn_patrol() -> void:
	var root: Node = get_tree().current_scene
	if root == null:
		return

	var player_pos := _get_player_pos_or_center()
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	_last_enemy_pos = player_pos

	for i in range(patrol_basic_count):
		_spawn_enemy(root, "basic", player_pos, rng)
	for i in range(patrol_sniper_count):
		_spawn_enemy(root, "sniper", player_pos, rng)
	for i in range(patrol_tank_count):
		_spawn_enemy(root, "tank", player_pos, rng)

func _spawn_enemy(root: Node, enemy_id: String, player_pos: Vector2, rng: RandomNumberGenerator) -> void:
	if EnemyScene == null:
		return
	var inst: Node = EnemyScene.instantiate()
	if not (inst is Node2D):
		return
	var e := inst as Node2D
	e.set("enemy_id", enemy_id)
	e.set("difficulty_multiplier", patrol_difficulty_multiplier)
	e.scale = patrol_enemy_scale

	var angle: float = rng.randf_range(0.0, TAU)
	var radius: float = patrol_spawn_radius + rng.randf_range(-patrol_spawn_jitter, patrol_spawn_jitter)
	e.global_position = player_pos + Vector2(cos(angle), sin(angle)) * radius

	root.add_child(e)

func _spawn_speaker() -> void:
	if EnemyScene == null:
		return
	if _speaker != null and is_instance_valid(_speaker):
		return

	var root: Node = get_tree().current_scene
	if root == null:
		return

	var inst: Node = EnemyScene.instantiate()
	if not (inst is Node2D):
		return
	var speaker := inst as Node2D
	speaker.set("enemy_id", speaker_enemy_id)
	speaker.set("difficulty_multiplier", speaker_difficulty_multiplier)
	speaker.scale = speaker_scale

	var player_pos := _get_player_pos_or_center()
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var angle: float = rng.randf_range(0.0, TAU)
	speaker.global_position = player_pos + Vector2(cos(angle), sin(angle)) * speaker_spawn_distance

	root.add_child(speaker)
	_speaker = speaker

func _spawn_leader() -> void:
	if EnemyScene == null:
		return
	if GameState.mid_core_patrol_cleared:
		return
	if _leader != null and is_instance_valid(_leader):
		return

	var root: Node = get_tree().current_scene
	if root == null:
		return

	var inst: Node = EnemyScene.instantiate()
	if not (inst is Node2D):
		return
	var leader := inst as Node2D
	leader.set("enemy_id", leader_enemy_id)
	leader.set("difficulty_multiplier", leader_difficulty_multiplier)
	leader.scale = leader_scale
	leader.add_to_group("core_event_leader")

	var player_pos := _get_player_pos_or_center()
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var angle: float = rng.randf_range(0.0, TAU)
	leader.global_position = player_pos + Vector2(cos(angle), sin(angle)) * leader_spawn_distance

	root.add_child(leader)
	_leader = leader
	_leader_last_pos = leader.global_position
	var hp_variant: Variant = leader.get("current_health")
	if hp_variant != null:
		_leader_last_hp = int(hp_variant)

	if leader.has_node("Sprite2D"):
		var sprite := leader.get_node("Sprite2D")
		if sprite is Sprite2D:
			(sprite as Sprite2D).modulate = leader_tint

	if leader.has_signal("died"):
		leader.connect("died", Callable(self, "_on_leader_died").bind(leader))
	elif leader.has_signal("tree_exiting"):
		leader.tree_exiting.connect(_on_leader_tree_exiting.bind(leader))

func _on_leader_died(_enemy: Node2D, leader: Node2D) -> void:
	if GameState.mid_core_patrol_cleared:
		return
	if leader == null:
		return
	GameState.mid_core_patrol_cleared = true
	GameState.complete_quest(GameState.QUEST_DEFEAT_HUMANS)
	GameState.queue_save()
	_spawn_relic(leader.global_position)

func _on_leader_tree_exiting(leader: Node2D) -> void:
	if GameState.mid_core_patrol_cleared:
		return
	if leader == null:
		return

	# Só dropa se morreu mesmo (na troca de zona o HP não está a 0).
	_last_enemy_pos = _leader_last_pos
	var hp: int = _leader_last_hp
	var hp_variant: Variant = leader.get("current_health")
	if hp_variant != null:
		hp = int(hp_variant)
		_last_enemy_pos = leader.global_position
	if hp > 0:
		return

	GameState.mid_core_patrol_cleared = true
	GameState.queue_save()
	_spawn_relic(_last_enemy_pos)

func _spawn_relic(world_pos: Vector2) -> void:
	# Pode ser chamado a partir de callbacks de física (ex: morte por laser).
	# Spawns de Area2D durante "flushing queries" dão erro, por isso adiamos para o próximo frame.
	if Engine.is_in_physics_frame():
		call_deferred("_spawn_relic_next_frame", world_pos)
		return
	_spawn_relic_now(world_pos)

func _spawn_relic_next_frame(world_pos: Vector2) -> void:
	if not is_inside_tree():
		return
	await get_tree().process_frame
	if not is_inside_tree():
		return
	_spawn_relic_now(world_pos)

func _spawn_relic_now(world_pos: Vector2) -> void:
	var required_core: int = ZoneCatalog.get_required_artifact_parts("core")
	if GameState.artifact_parts_collected >= required_core:
		return

	if RelicScene == null:
		return
	var zone_root := GameState.get_zone_root_node()
	var root: Node = zone_root as Node if zone_root != null else get_tree().current_scene
	if root == null:
		return

	var inst: Node = RelicScene.instantiate()
	if not (inst is Node2D):
		return
	var relic := inst as Node2D
	relic.set_as_top_level(true)
	relic.global_position = world_pos
	relic.scale = Vector2(1.25, 1.25)
	relic.set("artifact_id", "relic")
	relic.set("prompt_text", "E - Artefacto (Relic)")
	root.call_deferred("add_child", relic)

func _get_player_pos_or_center() -> Vector2:
	var p := get_tree().get_first_node_in_group("player")
	if p is Node2D:
		return (p as Node2D).global_position
	return global_position
