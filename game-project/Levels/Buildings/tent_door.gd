extends InteractionArea
class_name TentDoor

func _ready() -> void:
	action_name = "Enter Tent"
	interact = _on_interact

func _on_interact() -> void:
	EventBus.level_load_requested.emit("tent", "")
