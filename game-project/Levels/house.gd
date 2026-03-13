extends Node2D

## House level script — wires the door and bed interactions.

@onready var door_area: InteractionArea = $DoorArea
@onready var bed_area: InteractionArea = $BedArea

func _ready() -> void:
	door_area.action_name = "Leave House"
	door_area.interact = Callable(self, "_on_door_interact")
	bed_area.action_name = "Sleep"
	bed_area.interact = Callable(self, "_on_bed_interact")

func _on_door_interact() -> void:
	EventBus.level_load_requested.emit("camp_1", "")

func _on_bed_interact() -> void:
	EventBus.sleep_requested.emit()
