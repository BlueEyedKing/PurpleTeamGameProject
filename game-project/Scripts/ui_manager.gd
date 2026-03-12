extends Node

@onready var state_manager: Node = $"../StateManager"
@onready var ui: CanvasLayer = $"../../UI"

var pause_menu
var main_menu

func _ready() -> void:
	EventBus.pause_menu_show_requested.connect(show_pause_menu)
	EventBus.pause_menu_hide_requested.connect(hide_pause_menu)
	EventBus.show_main_menu_requested.connect(show_main_menu)
	EventBus.free_main_menu_requested.connect(free_main_menu)
func show_pause_menu() -> void:
	pause_menu = preload("res://UI/pause_menu.tscn").instantiate()
	pause_menu.save_and_quit_requested.connect(state_manager.save_and_quit)
	pause_menu.continue_requested.connect(state_manager.pop_state)
	ui.add_child(pause_menu)

func hide_pause_menu() -> void:
	if pause_menu:
		pause_menu.queue_free()
		pause_menu = null

func show_main_menu() -> void:
	main_menu = preload("res://UI/main_menu.tscn").instantiate()
	ui.add_child(main_menu)
	
func free_main_menu() -> void:
	if (main_menu):
		main_menu.queue_free()
		main_menu = null
