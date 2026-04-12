extends GameState
class_name MorningState

## MorningState — Player wakes up in the house.
## Walking to the door transitions to DaytimeState (camp_1).

var _transition_in_progress := false

func Enter() -> void:
	TimeManager.set_phase(TimeManager.Phase.MORNING)
	manager.level_manager.load_level("house")
	EventBus.level_load_requested.connect(_on_level_load_requested)

func Exit() -> void:
	if EventBus.level_load_requested.is_connected(_on_level_load_requested):
		EventBus.level_load_requested.disconnect(_on_level_load_requested)

func _on_level_load_requested(level: String, _gate: String) -> void:
	if level == "camp_1" and not _transition_in_progress:
		_transition_in_progress = true
		var transition = preload("res://MiscObjects/transition_screen.tscn").instantiate()
		manager.get_tree().root.add_child(transition)
		transition.transition()
		await transition.on_transition_finished
		manager.pop_state()
		manager.push_state(DaytimeState.new(manager))
		await transition.animation_player.animation_finished
		transition.queue_free()
