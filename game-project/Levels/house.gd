extends Node2D

## House interior — first-person point-and-click view.
## No player movement; player clicks buttons to interact.

@onready var door_button: Button = $CanvasLayer/DoorButton
@onready var bed_button: Button  = $CanvasLayer/BedButton

func _ready() -> void:
	door_button.pressed.connect(_on_door_pressed)
	bed_button.pressed.connect(_on_bed_pressed)

func _on_door_pressed() -> void:
	# In the morning the player leaves for the dig site.
	# At night the player returns to the city.
	if TimeManager.current_phase == TimeManager.Phase.MORNING:
		EventBus.level_load_requested.emit("camp_1", "")
	else:
		EventBus.level_load_requested.emit("main_city", "HouseDoor")

func _on_bed_pressed() -> void:
	EventBus.sleep_requested.emit()
