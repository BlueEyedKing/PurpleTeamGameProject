extends Node2D

@onready var inez: Node2D = $Inez
@onready var digsite: Marker2D = $Digsite

func _ready() -> void:
	EventBus.inez_leaves.connect(func(): inez.walk_to(digsite.global_position))
