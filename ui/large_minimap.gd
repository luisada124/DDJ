extends Control

@export var map_padding: float = 20.0

@export var player_color: Color = Color(0.2, 1.0, 0.2)
@export var artifact_color: Color = Color(1.0, 0.25, 0.25)
@export var trader_color: Color = Color(1.0, 0.85, 0.2)
@export var boss_planet_color: Color = Color(1.0, 0.45, 0.25)
@export var unknown_poi_color: Color = Color(0.8, 0.8, 0.9)

@export var station_label_font_size: int = 14
@export var station_label_offset: Vector2 = Vector2(0, -20)

var _player: Node2D = null
var _station_labels: Dictionary = {}  # station_id -> Label

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
	# Limpar labels antigas
	_clear_station_labels()
	
	# Fundo
	draw_rect(Rect2(Vector2.ZERO, size), Color(0, 0, 0, 0.6), true)
	draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, 0.3), false, 2.0)

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

	# Artifact parts reais (nodes na cena)
	var artifact_nodes: Array[Node] = get_tree().get_nodes_in_group("artifact_part")
	for n: Node in artifact_nodes:
		if n is Node2D:
			var artifact_pos: Vector2 = to_map.call((n as Node2D).global_position) as Vector2
			draw_circle(artifact_pos, 6.0, artifact_color)

	# Dica do mapa do Vacuum
	if GameState.vacuum_map_bought and not GameState.vacuum_random_part_collected and GameState.vacuum_random_part_world != Vector2.ZERO:
		var p: Vector2 = to_map.call(GameState.vacuum_random_part_world) as Vector2
		draw_circle(p, 8.0, Color(0.4, 0.9, 1.0, 0.95))
		draw_circle(p, 14.0, Color(0.4, 0.9, 1.0, 0.25))

	# Dica do mapa do Reverse Thruster
	if GameState.reverse_thruster_map_bought and not GameState.reverse_thruster_random_part_collected and GameState.reverse_thruster_random_part_world != Vector2.ZERO:
		var p_rt: Vector2 = to_map.call(GameState.reverse_thruster_random_part_world) as Vector2
		draw_circle(p_rt, 8.0, Color(1.0, 0.55, 0.9, 0.95))
		draw_circle(p_rt, 14.0, Color(1.0, 0.55, 0.9, 0.25))

	# Dica do mapa do Side Dash
	if GameState.side_dash_map_unlocked and not GameState.side_dash_random_part_collected and GameState.side_dash_random_part_world != Vector2.ZERO:
		var p_sd: Vector2 = to_map.call(GameState.side_dash_random_part_world) as Vector2
		draw_circle(p_sd, 8.0, Color(0.95, 0.75, 0.25, 0.95))
		draw_circle(p_sd, 14.0, Color(0.95, 0.75, 0.25, 0.25))

	# Dicas dos mapas do Auto Regen
	if GameState.auto_regen_map_zone1_bought and not GameState.auto_regen_part1_collected and GameState.auto_regen_part1_world != Vector2.ZERO:
		var p_ar1: Vector2 = to_map.call(GameState.auto_regen_part1_world) as Vector2
		draw_circle(p_ar1, 8.0, Color(0.55, 1.0, 0.55, 0.95))
		draw_circle(p_ar1, 14.0, Color(0.55, 1.0, 0.55, 0.25))
	if GameState.auto_regen_map_zone2_bought and not GameState.auto_regen_part2_collected and GameState.auto_regen_part2_world != Vector2.ZERO:
		var p_ar2: Vector2 = to_map.call(GameState.auto_regen_part2_world) as Vector2
		draw_circle(p_ar2, 8.0, Color(0.35, 0.85, 1.0, 0.95))
		draw_circle(p_ar2, 14.0, Color(0.35, 0.85, 1.0, 0.25))

	# Dica do mapa do Aux Ship
	if GameState.aux_ship_map_unlocked and not GameState.aux_ship_random_part_collected and GameState.aux_ship_random_part_world != Vector2.ZERO:
		var p_aux: Vector2 = to_map.call(GameState.aux_ship_random_part_world) as Vector2
		draw_circle(p_aux, 8.0, Color(0.9, 0.35, 1.0, 0.95))
		draw_circle(p_aux, 14.0, Color(0.9, 0.35, 1.0, 0.25))

	# Traders reais (planeta/loja) - COM NOMES
	var trader_nodes: Array[Node] = get_tree().get_nodes_in_group("trader")
	for n: Node in trader_nodes:
		if n is Node2D:
			var sid: Variant = n.get("station_id")
			var station_id := ""
			if sid != null:
				station_id = str(sid)

			# Boss planet é tratado por um marcador separado.
			if station_id == "boss_planet":
				continue

			# Estacoes só aparecem no minimapa depois de descobertas.
			if not station_id.is_empty() and not GameState.is_station_discovered(station_id):
				continue

			var station_pos: Vector2 = (n as Node2D).global_position
			var map_pos: Vector2 = to_map.call(station_pos) as Vector2
			
			var c := trader_color
			if not station_id.is_empty():
				c = StationCatalog.get_station_color(station_id)
			draw_circle(map_pos, 6.0, c)
			
			# Criar label com o nome da estação
			if not station_id.is_empty():
				_create_station_label(station_id, map_pos)

	# Jogador
	if _player != null and is_instance_valid(_player):
		var player_map_pos: Vector2 = to_map.call(_player.global_position) as Vector2
		draw_circle(player_map_pos, 5.0, player_color)

	# Marcador do planeta do boss
	if GameState.has_boss_planet_marker():
		var boss_markers: Array[Node] = get_tree().get_nodes_in_group("boss_planet_marker")
		for n: Node in boss_markers:
			if n is Node2D:
				var boss_pos := (n as Node2D).global_position
				if bounds.has_point(boss_pos):
					var map_pos: Vector2 = to_map.call(boss_pos) as Vector2
					draw_circle(map_pos, 6.0, boss_planet_color)
					_create_station_label("boss_planet", map_pos)

func _create_station_label(station_id: String, map_pos: Vector2) -> void:
	# Se já existe, atualizar posição
	if _station_labels.has(station_id):
		var label: Label = _station_labels[station_id]
		if is_instance_valid(label):
			label.position = map_pos + station_label_offset
			return
	
	# Criar novo label
	var label := Label.new()
	label.text = StationCatalog.get_station_title(station_id)
	label.add_theme_font_size_override("font_size", station_label_font_size)
	label.position = map_pos + station_label_offset
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	
	# Cor da estação
	if station_id != "boss_planet":
		var station_color := StationCatalog.get_station_color(station_id)
		label.add_theme_color_override("font_color", station_color)
	
	add_child(label)
	_station_labels[station_id] = label

func _clear_station_labels() -> void:
	# Remove todos os labels - serão recriados no próximo _draw
	for station_id in _station_labels.keys():
		var label: Label = _station_labels[station_id]
		if is_instance_valid(label):
			label.queue_free()
	_station_labels.clear()
