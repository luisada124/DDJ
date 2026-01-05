extends Camera2D

@export var zoom_speed := 0.15        # rapidez do tween
@export var min_zoom := 0.5
@export var max_zoom := 2.5
@export var zoom_input_enabled: bool = true

var target_zoom: Vector2

func _ready():
	# começa com o zoom atual
	target_zoom = zoom

func set_target_zoom_immediate(new_zoom: Vector2) -> void:
	target_zoom = new_zoom
	zoom = new_zoom

func get_target_zoom() -> Vector2:
	return target_zoom

func set_zoom_input_enabled(enabled: bool) -> void:
	zoom_input_enabled = enabled

func _unhandled_input(event):
	if not zoom_input_enabled:
		return

	# Scroll do rato
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_out()

	# Teclas + e -
	if Input.is_action_pressed("zoom_in"):
		_zoom_in()
	if Input.is_action_pressed("zoom_out"):
		_zoom_out()

func _process(delta):
	# interpolar suavemente o zoom atual até ao zoom alvo
	zoom = zoom.lerp(target_zoom, zoom_speed)

func _zoom_in():
	target_zoom -= Vector2(0.1, 0.1)
	_limit_zoom()

func _zoom_out():
	target_zoom += Vector2(0.1, 0.1)
	_limit_zoom()

func _limit_zoom():
	target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
	target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)
