extends GameState
class_name NightState

## NightState — Player is in main_city at night.
## Entering the house loads it. Sleeping in the bed advances the day.

var _transition_in_progress := false

func Enter() -> void:
	TimeManager.set_phase(TimeManager.Phase.NIGHT)
	manager.level_manager.load_level("main_city")
	EventBus.level_load_requested.connect(_on_level_load_requested)
	EventBus.sleep_requested.connect(_on_sleep_requested)

func Exit() -> void:
	if EventBus.level_load_requested.is_connected(_on_level_load_requested):
		EventBus.level_load_requested.disconnect(_on_level_load_requested)
	if EventBus.sleep_requested.is_connected(_on_sleep_requested):
		EventBus.sleep_requested.disconnect(_on_sleep_requested)

func _on_level_load_requested(level: String, gate: String) -> void:
	if _transition_in_progress:
		return
	_transition_in_progress = true
	var transition = preload("res://MiscObjects/transition_screen.tscn").instantiate()
	manager.get_tree().root.add_child(transition)
	transition.transition()
	await transition.on_transition_finished
	manager.level_manager.load_level(level, gate)
	await transition.animation_player.animation_finished
	transition.queue_free()
	_transition_in_progress = false

func _on_sleep_requested() -> void:
	if _transition_in_progress:
		return
	_transition_in_progress = true
	var transition = preload("res://MiscObjects/transition_screen.tscn").instantiate()
	manager.get_tree().root.add_child(transition)
	transition.transition()
	await transition.on_transition_finished
	TimeManager.advance_day()
	manager.pop_state()
	manager.push_state(MorningState.new(manager))
	await transition.animation_player.animation_finished
	transition.queue_free()
