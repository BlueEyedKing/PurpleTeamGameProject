extends Node2D

@onready var inez = $Inez
@onready var digsite: Marker2D = $TextBox3/Digsite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.inez_leaves.connect(func(): inez.walk_to(digsite.global_position))
