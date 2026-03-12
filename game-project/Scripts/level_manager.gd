extends Node

## LevelManager — loads and unloads level scenes.
## Scenes: "house", "camp_1", "main_city"

const HOUSE     = preload("res://Levels/house.tscn")
const CAMP_1    = preload("res://Levels/camp_1.tscn")
const MAIN_CITY = preload("res://Levels/main_city.tscn")

@onready var world: Node2D = $"../../World"

var current_level


func load_level(level: String) -> void:
	if current_level:
		current_level.queue_free()
	match level:
		"house":
			current_level = HOUSE.instantiate()
		"camp_1":
			current_level = CAMP_1.instantiate()
		"main_city":
			current_level = MAIN_CITY.instantiate()
		_:
			push_error("LevelManager: Unknown level '%s'" % level)
			return
	world.add_child(current_level)
	load_player()


func free_level() -> void:
	if current_level:
		world.remove_child(current_level)
		current_level.queue_free()
		current_level = null


func load_player() -> void:
	var player = preload("res://Player/Player.tscn").instantiate()
	current_level.add_child(player)
