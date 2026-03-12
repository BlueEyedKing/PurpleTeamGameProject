extends Node2D
class_name Gate

@onready var interaction_area: InteractionArea = $InteractionArea
@export var destination_level: String
@export var destination_gate: String

@onready var spawn_point: Marker2D = $SpawnPoint
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_open_gate")


func _open_gate():
	animated_sprite_2d.animation = "Open"
	# TODO forced animation of player walking out of city while screen fading out for example
	EventBus.level_load_requested.emit(destination_level, destination_gate)
	
