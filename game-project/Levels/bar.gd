extends Node2D

## Bar interior — first-person point-and-click view.

@onready var exit_button: Button = $CanvasLayer/ExitButton
@onready var florence_button: Button = $CanvasLayer/FlorenceButton

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)

	var current_day: int = GameData.get_value("current_day", 1)

	# Day 5 — bar is empty, no one to talk to
	if current_day == 5:
		florence_button.visible = false
		return

	# Who initiates the conversation each day
	var bar_npc: String
	match current_day:
		2, 4: bar_npc = "Aiden"    # Aiden + Oran at the bar
		_:    bar_npc = "Florence" # Day 1, 3 — Florence's scene

	florence_button.text = "Talk to " + bar_npc
	florence_button.pressed.connect(_on_talk_pressed.bind(florence_button, "Florence"))
	DialogueUi.dialog_finished.connect(func(): florence_button.visible = true)

func _on_talk_pressed(button: Button, npc_id: String) -> void:
	button.visible = false
	DialogueUi.start_for_npc(npc_id)

func _on_exit_pressed() -> void:
	EventBus.level_load_requested.emit("main_city", "BarDoor")
