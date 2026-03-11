extends Control

@onready var start_button: Button = $VBoxContainer/NinePatchRect/StartButton
@onready var quit_button: Button = $VBoxContainer/NinePatchRect3/QuitButton

signal start_requested

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
func _on_start_pressed() -> void:
	start_requested.emit()
	
func _on_quit_pressed() -> void:
	#manager.clear_stack() ?
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
