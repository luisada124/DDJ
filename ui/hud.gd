extends CanvasLayer

@onready var health_label: Label = $HealthContainer/HealthLabel
@onready var scrap_label: Label = $ResourcesContainer/ResourcesBox/ScrapLabel
@onready var mineral_label: Label = $ResourcesContainer/ResourcesBox/MineralLabel

func _process(delta: float) -> void:
	# Vida
	var hp := GameState.player_health
	var max_hp := GameState.player_max_health
	health_label.text = "HP: %d / %d" % [hp, max_hp]

	# Recursos
	scrap_label.text = "Scrap: %d" % GameState.resources.get("scrap", 0)
	mineral_label.text = "  |  Mineral: %d" % GameState.resources.get("mineral", 0)
