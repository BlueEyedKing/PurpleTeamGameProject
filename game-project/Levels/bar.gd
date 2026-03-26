extends Node2D

## Bar interior — first-person point-and-click view.

@onready var exit_button: Button = $CanvasLayer/ExitButton
@onready var florence_button: Button = $CanvasLayer/FlorenceButton

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)
	florence_button.pressed.connect(func():
		florence_button.release_focus()
		DialogueUi.start_for_npc("Florence"))

func _on_exit_pressed() -> void:
	EventBus.level_load_requested.emit("main_city", "bar")
