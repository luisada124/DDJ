extends Area2D

@export var speed: float = 800.0
@export var damage: int = 5
@export var damage_upgrade_id: String = ""

var direction: Vector2 = Vector2.UP
var inherited_velocity: Vector2 = Vector2.ZERO
var lifetime: float = 2.0

# true = tiro do player, false = tiro de inimigo
var from_player: bool = true

const _LAYER_PLAYER := 1
const _LAYER_COMET := 2
const _LAYER_ENEMY := 8
const _BASE_PROJECTILE_SCALE := 1.35
const _PROJECTILE_SCALE_PER_DAMAGE_LEVEL := 0.045
const _MAX_PROJECTILE_SCALE := 2.0

func _ready() -> void:
	# Ajusta colisões conforme o dono do tiro (evita lasers do player a baterem no player)
	_apply_projectile_size()
	if from_player:
		_apply_player_color()
		collision_mask = _LAYER_COMET | _LAYER_ENEMY
	else:
		collision_mask = _LAYER_PLAYER


func _apply_projectile_size() -> void:
	var sprite: Sprite2D = null
	var collision: CollisionShape2D = null
	if has_node("Sprite2D"):
		sprite = $Sprite2D as Sprite2D
	if has_node("CollisionShape2D"):
		collision = $CollisionShape2D as CollisionShape2D
	if sprite == null and collision == null:
		return

	var scale_mult := _BASE_PROJECTILE_SCALE
	if from_player:
		var upgrade_id := damage_upgrade_id
		if upgrade_id == "":
			upgrade_id = "laser_damage"
		var level := GameState.get_upgrade_level(upgrade_id)
		scale_mult += float(level) * _PROJECTILE_SCALE_PER_DAMAGE_LEVEL
	scale_mult = minf(scale_mult, _MAX_PROJECTILE_SCALE)

	var s := Vector2.ONE * scale_mult
	if sprite != null:
		sprite.scale = s
	if collision != null:
		collision.scale = s

func _apply_player_color() -> void:
	if not has_node("Sprite2D"):
		return
	var sprite := $Sprite2D as Sprite2D
	var level := GameState.get_upgrade_level("laser_damage")
	if level >= 5:
		sprite.modulate = Color(1.0, 1.0, 0.0)
	else:
		sprite.modulate = Color(1, 1, 1)

func _physics_process(delta: float) -> void:
	global_position += (direction * speed + inherited_velocity) * delta

	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	# print("LASER hit:", body, " groups =", body.get_groups())

	if from_player:
		# ========= TIRO DO PLAYER =========
		# Acerta cometas
		if body.is_in_group("comet") and body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
			return

		# Acerta inimigos
		if body.is_in_group("enemy") and body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
			return

	else:
		# ========= TIRO DO INIMIGO =========
		# Só interessa o player
		if body.is_in_group("alien") and body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
			return

		if body.is_in_group("ship") and body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
			return

		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
			else:
				GameState.damage_player(damage)
			queue_free()
			return

	# Se chegou aqui:
	# - tiro do player que bateu no player
	# - tiro do player que bateu em parede/pickup/etc
	# - tiro do inimigo que bateu em inimigo/cometa
	# -> ignorar completamente (não dano, não destruir laser)
