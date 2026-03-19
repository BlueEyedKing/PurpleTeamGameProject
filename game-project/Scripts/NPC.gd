extends Node2D
class_name NPC

@onready var interaction_area: InteractionArea = $InteractionArea
@export var npc_id: String

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	DialogueUi.start_for_npc(npc_id)
