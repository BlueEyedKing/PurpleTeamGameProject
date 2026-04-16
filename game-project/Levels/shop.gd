extends Node2D

## Shop interior — first-person point-and-click view.

@onready var exit_button: Button = $CanvasLayer/ExitButton
@onready var aiden_button: Button = $CanvasLayer/AidenButton

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)
	var current_day: int = GameData.get_value("current_day", 1)
	var shop_npc: String = "Oran" if current_day == 4 else "Aiden"
	aiden_button.text = "Talk to " + shop_npc
	aiden_button.pressed.connect(_on_talk_pressed.bind(aiden_button, shop_npc))
	DialogueUi.dialog_finished.connect(func(): aiden_button.visible = true)

func _on_talk_pressed(button: Button, npc_id: String) -> void:
	button.visible = false
	DialogueUi.start_for_npc(npc_id)

func _on_exit_pressed() -> void:
	EventBus.level_load_requested.emit("main_city", "ShopDoor")
