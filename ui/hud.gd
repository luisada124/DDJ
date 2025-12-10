extends Control

@onready var health_label: Label = $HealthContainer/HealthLabel
@onready var scrap_label: Label = $ResourcesContainer/ResourcesBox/ScrapLabel
@onready var mineral_label: Label = $ResourcesContainer/ResourcesBox/MineralLabel

func _process(delta: float) -> void:
	# Vida
	var hp: int = GameState.player_health
	var max_hp: int = GameState.player_max_health
	health_label.text = "HP: %d / %d" % [hp, max_hp]

	# Recursos
	var scrap: int = GameState.resources.get("scrap", 0)
	var mineral: int = GameState.resources.get("mineral", 0)

	scrap_label.text = "Scrap: %d" % scrap
	mineral_label.text = "Mineral: %d" % mineral
