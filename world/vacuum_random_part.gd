extends "res://pickups/artifact_part.gd"

@export var bounds_local: Rect2 = Rect2(-3072, -3072, 6144, 6144)
@export var margin: float = 250.0

func _ready() -> void:
	artifact_id = "vacuum"
	show_on_minimap = false

	if GameState.vacuum_random_part_collected:
		queue_free()
		return

	_ensure_position()
	super()
	# O ZoneManager pode aplicar transform (offset/scale) depois do _ready. Atualiza o marcador
	# numa frame seguinte para o minimapa bater certo com a posição real.
	call_deferred("_refresh_world_marker")

func _process(delta: float) -> void:
	# Só fica visível/usável quando o Vacuum estiver partido.
	var should_be_active := GameState.vacuum_is_broken and not GameState.vacuum_random_part_collected
	visible = should_be_active
	monitoring = should_be_active
	monitorable = should_be_active

	# Mantém o world marker correto quando o mapa estiver comprado (sem gravar em save).
	if should_be_active and GameState.vacuum_map_bought:
		GameState.vacuum_random_part_world = global_position
	super(delta)

func _refresh_world_marker() -> void:
	if not is_inside_tree():
		return
	GameState.vacuum_random_part_world = global_position

func _ensure_position() -> void:
	var stored := GameState.vacuum_random_part_local
	if stored != Vector2.ZERO:
		position = stored
		return

	var r := bounds_local.grow(-margin)
	var x := randf_range(r.position.x, r.position.x + r.size.x)
	var y := randf_range(r.position.y, r.position.y + r.size.y)
	position = Vector2(x, y)

	GameState.vacuum_random_part_local = position
	GameState.queue_save()

func _on_body_entered(body: Node2D) -> void:
	if body != null and body.is_in_group("player"):
		GameState.vacuum_random_part_collected = true
		GameState.vacuum_random_part_world = Vector2.ZERO
		GameState.queue_save()
	super(body)
