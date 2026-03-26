extends Node2D

## Bar interior — first-person point-and-click view.

@onready var exit_button: Button = $CanvasLayer/ExitButton
@onready var florence_button: Button = $CanvasLayer/FlorenceButton

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)
	florence_button.pressed.connect(_on_talk_pressed.bind(florence_button, "Florence"))
	DialogueUi.dialog_finished.connect(func(): florence_button.visible = true)

func _on_talk_pressed(button: Button, npc_id: String) -> void:
	button.visible = false
	DialogueUi.start_for_npc(npc_id)

func _on_exit_pressed() -> void:
	EventBus.level_load_requested.emit("main_city", "BarDoor")
