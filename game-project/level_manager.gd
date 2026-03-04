extends Node

const CAMP_1 = preload("res://Levels/camp_1.tscn")
const MAIN_CITY = preload("res://Levels/main_city.tscn")
@onready var world: Node2D = $"../../World"

var save = "camp_1" #savefile.current_level

var current_level

func load_level(level: String):
	if current_level:
		current_level.queue_free()
	match level:
		"camp_1":
			current_level = CAMP_1.instantiate()
		"main_city":
			current_level = MAIN_CITY.instantiate()
	world.add_child(current_level)
	
	load_player()

func free_level():
	if current_level:
		world.remove_child(current_level)
		current_level.queue_free()
		current_level = null

func load_player():
	var player = preload("res://Player/Player.tscn").instantiate()
	current_level.add_child(player)
	
	#camera.target = player
