extends Node2D

const TraderPlanetScene: PackedScene = preload("res://world/TraderPlanet.tscn")
const ArtifactPartScene: PackedScene = preload("res://pickups/ArtifactPart.tscn")

const INTRO_STATION_ID := "station_kappa"

@export var station_offset_from_player: Vector2 = Vector2(260, 120)
@export var drill_offset_from_player: Vector2 = Vector2(-320, -40)
@export var drill_min_distance_from_station: float = 240.0

func _ready() -> void:
	call_deferred("_setup")

func _setup() -> void:
	if GameState.current_zone_id != "mid":
		return

	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	_ensure_intro_station(player)
	_ensure_drill_part(player)

func _ensure_intro_station(player: Node2D) -> void:
	if _find_trader_by_station_id(INTRO_STATION_ID) != null:
		return

	# Define uma vez (primeira entrada na zona 2) e guarda para futuras visitas.
	if GameState.zone2_intro_station_local == Vector2.ZERO:
		var target_global := player.global_position + station_offset_from_player
		GameState.zone2_intro_station_local = to_local(target_global)
		GameState.queue_save()

	if TraderPlanetScene == null:
		return

	var inst: Node = TraderPlanetScene.instantiate()
	if inst == null:
		return
	if not (inst is Node2D):
		return

	var station := inst as Node2D
	station.position = GameState.zone2_intro_station_local
	station.set("station_id", INTRO_STATION_ID)
	station.set("prompt_text", "E - Posto Kappa")

	# Este posto é só para a intro (sem guardas).
	var guard_spawner: Node = station.get_node_or_null("StationGuardSpawner")
	if guard_spawner != null:
		guard_spawner.set("enabled", false)
		guard_spawner.set("max_guards", 0)
		guard_spawner.set_process(false)
		guard_spawner.set_physics_process(false)

	add_child(station)
	GameState.discover_station(INTRO_STATION_ID)

func _ensure_drill_part(player: Node2D) -> void:
	if GameState.has_artifact("mining_drill"):
		return
	if not GameState.zone2_drill_given:
		return
	if _find_artifact_part("mining_drill") != null:
		return

	if GameState.mining_drill_part_local == Vector2.ZERO:
		var target_global := player.global_position + drill_offset_from_player
		GameState.mining_drill_part_local = to_local(target_global)
		GameState.queue_save()
	elif GameState.zone2_intro_station_local != Vector2.ZERO:
		var drill_local := GameState.mining_drill_part_local
		if drill_local.distance_to(GameState.zone2_intro_station_local) < drill_min_distance_from_station:
			var target_global := player.global_position + drill_offset_from_player
			var new_local := to_local(target_global)
			if new_local.distance_to(GameState.zone2_intro_station_local) < drill_min_distance_from_station:
				var dir := new_local - GameState.zone2_intro_station_local
				if dir.length() < 0.001:
					dir = Vector2.LEFT
				else:
					dir = dir.normalized()
				new_local = GameState.zone2_intro_station_local + dir * drill_min_distance_from_station
			GameState.mining_drill_part_local = new_local
			GameState.queue_save()

	if ArtifactPartScene == null:
		return

	var inst: Node = ArtifactPartScene.instantiate()
	if inst == null:
		return
	if not (inst is Node2D):
		return

	var part := inst as Node2D
	part.position = GameState.mining_drill_part_local
	part.set("artifact_id", "mining_drill")
	add_child(part)

func _find_trader_by_station_id(station_id: String) -> Node:
	for n in get_tree().get_nodes_in_group("trader"):
		if n == null:
			continue
		var sid: Variant = n.get("station_id")
		if sid != null and str(sid) == station_id:
			return n
	return null

func _find_artifact_part(artifact_id: String) -> Node:
	for n in get_tree().get_nodes_in_group("artifact_part"):
		if n == null:
			continue
		var aid: Variant = n.get("artifact_id")
		if aid != null and str(aid) == artifact_id:
			return n
	return null
