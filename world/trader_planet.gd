extends Area2D

@export var station_id: String = "station_alpha"
@export var prompt_text: String = "E - Estacao"
@export var planet_texture: Texture2D

var _player_in_range: bool = false
var _access_registered: bool = false
var _blocked_by_guards: bool = false

@onready var prompt: Label = $Prompt
@onready var sprite: Sprite2D = $Sprite2D
@onready var guard_spawner: Node = get_node_or_null("StationGuardSpawner")

func _ready() -> void:
	add_to_group("trader")
	add_to_group("station")
	prompt.visible = false
	prompt.text = prompt_text
	set_process(true)

	# Render: manter o planeta "atrás" de tudo, mas o prompt sempre visível por cima.
	if sprite != null:
		sprite.z_as_relative = false
		sprite.z_index = -1000
	if prompt != null:
		prompt.z_as_relative = false
		prompt.z_index = 1000

	if planet_texture != null:
		sprite.texture = planet_texture
	if not station_id.is_empty():
		prompt.text = StationCatalog.get_prompt(station_id)
		sprite.modulate = StationCatalog.get_station_color(station_id)

	# Conectar ao sinal de wave_completed do guard spawner
	if guard_spawner != null and guard_spawner.has_signal("wave_completed"):
		guard_spawner.wave_completed.connect(_on_guards_defeated)

func is_player_in_range() -> bool:
	return _player_in_range

func _process(_delta: float) -> void:
	if not _player_in_range:
		return
	_refresh_access_state()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	_player_in_range = true
	prompt.visible = true
	_refresh_access_state()

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	_player_in_range = false
	prompt.visible = false
	_set_access_registered(false)

func _refresh_access_state() -> void:
	var blocked := _is_blocked_by_guards()
	if blocked:
		if prompt != null:
			var kills := 0
			var total := 0
			if guard_spawner != null:
				if guard_spawner.has_method("get_wave_kills"):
					kills = int(guard_spawner.call("get_wave_kills"))
				if guard_spawner.has_method("get_wave_total"):
					total = int(guard_spawner.call("get_wave_total"))
			if total > 0:
				prompt.text = "Elimina guardas (%d/%d)" % [kills, total]
			else:
				prompt.text = "Elimina os guardas"
		_set_access_registered(false)
		_blocked_by_guards = true
		return

	_blocked_by_guards = false
	if prompt != null:
		prompt.text = StationCatalog.get_prompt(station_id) if not station_id.is_empty() else prompt_text
	_set_access_registered(true)

func _set_access_registered(enable: bool) -> void:
	if enable == _access_registered:
		return
	_access_registered = enable
	get_tree().call_group("hud", "register_station_in_range", self, station_id, enable)
	get_tree().call_group("hud", "register_trader_in_range", self, enable)

func _is_blocked_by_guards() -> bool:
	if guard_spawner == null:
		return false
	if not guard_spawner.has_method("is_wave_cleared"):
		return false
	return not bool(guard_spawner.call("is_wave_cleared"))

func _on_guards_defeated() -> void:
	var station_title := StationCatalog.get_station_title(station_id)
	GameState.emit_signal("speech_requested", "Guardas eliminados! Vai falar com os NPCs do %s." % station_title)
