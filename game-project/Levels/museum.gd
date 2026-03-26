extends Node2D

## Museum interior — first-person point-and-click view.

@onready var exit_button: Button = $CanvasLayer/ExitButton
@onready var camila_button: Button = $CanvasLayer/CamilaButton

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)
	camila_button.pressed.connect(func():
		camila_button.release_focus()
		DialogueUi.start_for_npc("Camila"))

func _on_exit_pressed() -> void:
	EventBus.level_load_requested.emit("main_city", "museum")
