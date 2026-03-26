extends Node

@onready var state_manager: Node = $"../StateManager"
@onready var ui: CanvasLayer = $"../../UI"

var pause_menu
var main_menu
var time_hud
var settings

func _ready() -> void:
	EventBus.pause_menu_show_requested.connect(show_pause_menu)
	EventBus.pause_menu_hide_requested.connect(hide_pause_menu)
	EventBus.settings_show_requested.connect(show_settings)
	EventBus.settings_hide_requested.connect(hide_settings)
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

func show_settings() -> void:
	settings = preload("res://UI/settings.tscn").instantiate()
	ui.add_child(settings)
	settings.close_requested.connect(func():
		state_manager.pop_state())

func hide_settings() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	if settings:
		settings.queue_free()
		settings = null

func show_main_menu(has_save: bool) -> void:
	main_menu = preload("res://UI/main_menu.tscn").instantiate()
	ui.add_child(main_menu)
	main_menu.set_has_save(has_save)
	
func free_main_menu() -> void:
	if (main_menu):
		main_menu.queue_free()
		main_menu = null

func show_time_hud() -> void:
	if not time_hud:
		time_hud = preload("res://UI/time_hud.tscn").instantiate()
		ui.get_node("HUD").add_child(time_hud)

func hide_time_hud() -> void:
	if time_hud:
		time_hud.queue_free()
		time_hud = null
