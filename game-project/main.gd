extends Node

@onready var state_manager = $StateManager
@onready var ui = $UI


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu = preload("res://UI/main_menu.tscn").instantiate()
	menu.manager = state_manager
	ui.add_child(menu)
	
