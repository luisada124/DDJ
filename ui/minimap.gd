extends Control

@export var map_padding: float = 6.0

@export var player_color: Color = Color(0.2, 1.0, 0.2)
@export var artifact_color: Color = Color(1.0, 0.25, 0.25)
@export var trader_color: Color = Color(1.0, 0.85, 0.2)
@export var boss_planet_color: Color = Color(1.0, 0.45, 0.25)
@export var unknown_poi_color: Color = Color(0.8, 0.8, 0.9)

@export var draw_catalog_pois: bool = false

var _player: Node2D = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameState.state_changed.connect(queue_redraw)
	_refresh_player()

func _process(_delta: float) -> void:
	if _player == null or not is_instance_valid(_player):
		_refresh_player()
	queue_redraw()

func _refresh_player() -> void:
	var p := get_tree().get_first_node_in_group("player")
	if p is Node2D:
		_player = p as Node2D

func _draw() -> void:
	# Fundo
	draw_rect(Rect2(Vector2.ZERO, size), Color(0, 0, 0, 0.45), true)
	draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, 0.25), false, 1.0)

	var bounds: Rect2 = GameState.zone_bounds_world
	if bounds.size.x <= 0.0 or bounds.size.y <= 0.0:
		return

	var inner_pos := Vector2(map_padding, map_padding)
	var inner_size := Vector2(max(1.0, size.x - map_padding * 2.0), max(1.0, size.y - map_padding * 2.0))
	var inner_rect := Rect2(inner_pos, inner_size)

	# Helper: mundo -> minimapa
	var to_map := func(world_pos: Vector2) -> Vector2:
		var t := (world_pos - bounds.position) / bounds.size
		t.x = clamp(t.x, 0.0, 1.0)
		t.y = clamp(t.y, 0.0, 1.0)
		return inner_rect.position + t * inner_rect.size

	# POIs (catálogo): desliga por defeito até existirem objectos reais no mundo.
	if draw_catalog_pois:
		for poi in GameState.zone_pois_world:
			if typeof(poi) != TYPE_DICTIONARY:
				continue
			var d: Dictionary = poi
			var poi_type := str(d.get("type", ""))
			var pos: Vector2 = d.get("pos", Vector2.ZERO)
			var c := unknown_poi_color
			match poi_type:
				"artifact":
					c = artifact_color
				"trader":
					c = trader_color
			draw_circle(to_map.call(pos), 4.0, c)

	# Artifact parts reais (nodes na cena)
	var artifact_nodes: Array[Node] = get_tree().get_nodes_in_group("artifact_part")
	for n: Node in artifact_nodes:
		if n is Node2D:
			draw_circle(to_map.call((n as Node2D).global_position), 4.0, artifact_color)

	# Dica do mapa do Vacuum (apenas se comprado e ainda existir a peça aleatória)
	if GameState.vacuum_map_bought and not GameState.vacuum_random_part_collected and GameState.vacuum_random_part_world != Vector2.ZERO:
		var p: Vector2 = to_map.call(GameState.vacuum_random_part_world)
		draw_circle(p, 6.0, Color(0.4, 0.9, 1.0, 0.95))
		draw_circle(p, 10.0, Color(0.4, 0.9, 1.0, 0.25))

	# Dica do mapa do Reverse Thruster (apenas se comprado e ainda existir a peca aleatoria)
	if GameState.reverse_thruster_map_bought and not GameState.reverse_thruster_random_part_collected and GameState.reverse_thruster_random_part_world != Vector2.ZERO:
		var p_rt: Vector2 = to_map.call(GameState.reverse_thruster_random_part_world)
		draw_circle(p_rt, 6.0, Color(1.0, 0.55, 0.9, 0.95))
		draw_circle(p_rt, 10.0, Color(1.0, 0.55, 0.9, 0.25))

	# Dica do mapa do Side Dash (map por missao na Zona 2)
	if GameState.side_dash_map_unlocked and not GameState.side_dash_random_part_collected and GameState.side_dash_random_part_world != Vector2.ZERO:
		var p_sd: Vector2 = to_map.call(GameState.side_dash_random_part_world)
		draw_circle(p_sd, 6.0, Color(0.95, 0.75, 0.25, 0.95))
		draw_circle(p_sd, 10.0, Color(0.95, 0.75, 0.25, 0.25))

	# Dicas dos mapas do Auto Regen (2 pecas aleatorias na Zona 2)
	if GameState.auto_regen_map_zone1_bought and not GameState.auto_regen_part1_collected and GameState.auto_regen_part1_world != Vector2.ZERO:
		var p_ar1: Vector2 = to_map.call(GameState.auto_regen_part1_world)
		draw_circle(p_ar1, 6.0, Color(0.55, 1.0, 0.55, 0.95))
		draw_circle(p_ar1, 10.0, Color(0.55, 1.0, 0.55, 0.25))
	if GameState.auto_regen_map_zone2_bought and not GameState.auto_regen_part2_collected and GameState.auto_regen_part2_world != Vector2.ZERO:
		var p_ar2: Vector2 = to_map.call(GameState.auto_regen_part2_world)
		draw_circle(p_ar2, 6.0, Color(0.35, 0.85, 1.0, 0.95))
		draw_circle(p_ar2, 10.0, Color(0.35, 0.85, 1.0, 0.25))

	# Dica do mapa do Aux Ship (map por missao na Zona 2)
	if GameState.aux_ship_map_unlocked and not GameState.aux_ship_random_part_collected and GameState.aux_ship_random_part_world != Vector2.ZERO:
		var p_aux: Vector2 = to_map.call(GameState.aux_ship_random_part_world)
		draw_circle(p_aux, 6.0, Color(0.9, 0.35, 1.0, 0.95))
		draw_circle(p_aux, 10.0, Color(0.9, 0.35, 1.0, 0.25))

	# Traders reais (planeta/loja)
	var trader_nodes: Array[Node] = get_tree().get_nodes_in_group("trader")
	for n: Node in trader_nodes:
		if n is Node2D:
			var c := trader_color
			var sid: Variant = n.get("station_id")
			if sid != null:
				c = StationCatalog.get_station_color(str(sid))
			draw_circle(to_map.call((n as Node2D).global_position), 4.0, c)

	# Jogador
	if _player != null and is_instance_valid(_player):
			draw_circle(to_map.call(_player.global_position), 3.5, player_color)

	# Marcador do planeta do boss (libertado pela ultima missao do cacador).
	if GameState.has_boss_planet_marker():
		var boss_markers: Array[Node] = get_tree().get_nodes_in_group("boss_planet_marker")
		for n: Node in boss_markers:
			if n is Node2D:
				var boss_pos := (n as Node2D).global_position
				if bounds.has_point(boss_pos):
					draw_circle(to_map.call(boss_pos), 4.5, boss_planet_color)
