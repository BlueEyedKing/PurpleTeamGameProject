extends Node2D
class_name NPC

@onready var interaction_area: InteractionArea = $InteractionArea
@export var npc_id: String

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	_apply_placement()
	EventBus.npc_startled.connect(_on_startled)
	
func _on_interact():
	DialogueUi.start_for_npc(npc_id)

func _apply_placement() -> void:
	if npc_id == "":
		return

	var marker_name = npc_id + "_day" + str(TimeManager.current_day)
	var marker = get_parent().get_node_or_null(marker_name)
	if marker:
		global_position = marker.global_position
		return
	var default_marker = get_parent().get_node_or_null(npc_id + "_default")
	if default_marker:
		global_position = default_marker.global_position
	else:
		queue_free()
		
func _on_startled(id: String) -> void:
	if id != npc_id:
		return
	_do_startle()

# If you'd want diff startle animations for diff characters -> could edit own scripts
func _do_startle() -> void:
	var original_pos = position
	var tween = create_tween()
	tween.tween_property(self, "position", original_pos + Vector2(0, -6), 0.08)
	tween.tween_property(self, "position", original_pos, 0.12)
