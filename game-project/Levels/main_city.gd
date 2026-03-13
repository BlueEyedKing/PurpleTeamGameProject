extends Node2D

## Main city level script — wires the door to the house.

@onready var house_door: InteractionArea = $HouseDoor

func _ready() -> void:
	house_door.action_name = "Enter House"
	house_door.interact = Callable(self, "_on_house_door_interact")

func _on_house_door_interact() -> void:
	EventBus.level_load_requested.emit("house", "")
