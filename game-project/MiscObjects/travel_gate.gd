extends Node2D
class_name Gate

@onready var interaction_area: InteractionArea = $InteractionArea
@export var destination_level: String
@export var destination_gate: String

@onready var spawn_point: Marker2D = $SpawnPoint
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const lines: Array[String] = [
	"hmm...",
	"I think I have some unfinished business here still "
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_open_gate")


func _open_gate():
	animated_sprite_2d.animation = "Open"
	interaction_area.action_name = "Leave"
	# TODO forced animation of player walking out of city while screen fading out for example
	if (GameData.has_flag("work_done")):
		EventBus.level_load_requested.emit(destination_level, destination_gate)
	else:
		InteractionManager.lock(self)
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.set_physics_process(false)
		InfoBubble.start_text(global_position, lines)
		await InfoBubble.text_finished
		InteractionManager.unlock(self)
		player = get_tree().get_first_node_in_group("player")
		if player:
			player.set_physics_process(true)
