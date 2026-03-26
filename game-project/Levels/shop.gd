extends Node2D

## Shop interior — first-person point-and-click view.

@onready var exit_button: Button = $CanvasLayer/ExitButton
@onready var aiden_button: Button = $CanvasLayer/AidenButton

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)
	aiden_button.pressed.connect(func():
		aiden_button.release_focus()
		DialogueUi.start_for_npc("Aiden"))

func _on_exit_pressed() -> void:
	EventBus.level_load_requested.emit("main_city", "ShopDoor")
