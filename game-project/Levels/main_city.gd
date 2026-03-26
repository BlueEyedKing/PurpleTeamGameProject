extends Node2D

## Main city level script — wires building entrances.

@onready var house_door: InteractionArea  = $HouseDoor
@onready var museum_door: InteractionArea = $museum
@onready var bar_door: InteractionArea    = $bar
@onready var shop_door: InteractionArea   = $shop

func _ready() -> void:
	house_door.action_name = "Enter House"
	house_door.interact = Callable(self, "_on_house_door_interact")

	museum_door.action_name = "Enter Museum"
	museum_door.interact = Callable(self, "_on_museum_door")

	bar_door.action_name = "Enter Bar"
	bar_door.interact = Callable(self, "_on_bar_door")

	shop_door.action_name = "Enter Shop"
	shop_door.interact = Callable(self, "_on_shop_door")

func _on_house_door_interact() -> void:
	EventBus.level_load_requested.emit("house", "")

func _on_museum_door() -> void:
	EventBus.level_load_requested.emit("museum", "")

func _on_bar_door() -> void:
	EventBus.level_load_requested.emit("bar", "")

func _on_shop_door() -> void:
	EventBus.level_load_requested.emit("shop", "")
