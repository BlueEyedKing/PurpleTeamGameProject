extends Node

@onready var state_manager: Node = $"../../StateManager"
@onready var ui: Control = $"../../UI"

var pause_menu

func show_pause_menu():
	pause_menu = preload("res://UI/pause_menu.tscn").instantiate()
	pause_menu.save_and_quit_requested.connect(state_manager.save_and_quit)
	pause_menu.continue_requested.connect(state_manager.pop_state)
	ui.add_child(pause_menu)

func hide_pause_menu():
	if pause_menu:
		pause_menu.queue_free()
		pause_menu = null
