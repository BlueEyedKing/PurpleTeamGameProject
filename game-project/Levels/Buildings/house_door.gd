extends InteractionArea
class_name HouseDoor

func _ready() -> void:
	action_name = "Enter House"
	interact = _on_interact

func _on_interact() -> void:
	EventBus.level_load_requested.emit("house", "")
