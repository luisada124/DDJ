extends Resource

class_name EnemyData

@export var id: String = "basic"
@export var display_name: String = "Basic"

@export var move_speed: float = 250.0
@export var desired_distance: float = 300.0
@export var distance_tolerance: float = 20.0
@export var chase_range: float = 2000.0
@export var texture: Texture2D
@export var max_health: int = 30
@export var contact_damage: int = 10

@export var fire_interval: float = 1.2
@export var laser_damage: int = 5
@export var laser_scene_path: String = "res://player/lasers/Laser.tscn"

@export var pickup_scene_path: String = "res://pickups/Pickup.tscn"
@export var min_drops: int = 1
@export var max_drops: int = 3
@export var mineral_drop_chance: float = 0.25
@export var scrap_amount: int = 1
@export var mineral_amount: int = 1
