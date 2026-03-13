extends Control

@onready var continue_button: Button = $VBoxContainer/NinePatchRect/ContinueButton
@onready var quit_button: Button = $VBoxContainer/NinePatchRect3/QuitButton
const button_sfx = preload("uid://de4ikle11vwli") #GAME_PROJECT_2_MENU_CLICK

signal save_and_quit_requested
signal continue_requested

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #PROCESS_MODE_WHEN_PAUSED
	continue_button.pressed.connect(_on_continue_pressed)
	quit_button.pressed.connect(_on_save_and_quit_pressed)
	
func _on_continue_pressed() -> void:
	AudioManager.play_sfx(button_sfx)
	continue_requested.emit()
	
func _on_save_and_quit_pressed() -> void:
	AudioManager.play_sfx(button_sfx)
	save_and_quit_requested.emit()
