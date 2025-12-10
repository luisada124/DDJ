extends Node

var player_max_health: int = 100
var player_health: int = 100

var resources := {
	"scrap": 0,
	"mineral": 0,
}

func add_resource(type: String, amount: int) -> void:
	if not resources.has(type):
		resources[type] = 0
	resources[type] += amount
	print(type, " =", resources[type])

func damage_player(amount: int) -> void:
	player_health = max(player_health - amount, 0)

func heal_player(amount: int) -> void:
	player_health = min(player_health + amount, player_max_health)
