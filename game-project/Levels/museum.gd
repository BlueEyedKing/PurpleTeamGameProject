extends Node2D

## Museum interior — first-person point-and-click view.

@onready var exit_button: Button = $CanvasLayer/ExitButton

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)

func _on_exit_pressed() -> void:
	EventBus.level_load_requested.emit("main_city", "museum")
