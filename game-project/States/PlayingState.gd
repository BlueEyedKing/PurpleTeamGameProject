extends GameState
class_name PlayingState

## PlayingState — Entry point into gameplay.
## Immediately delegates to MorningState to begin the day cycle.
## This keeps PlayingState as the "game is active" marker while
## the day-phase states handle level loading themselves.

func Enter() -> void:
	# Show the time HUD and objective HUD when gameplay starts
	var ui_manager = manager.get_node("../UIManager")
	if ui_manager:
		ui_manager.show_time_hud()
		ui_manager.show_objective_hud()
	# Push MorningState on top; PlayingState stays as base of the play stack
	manager.push_state(MorningState.new(manager))

func Exit() -> void:
	# Hide the time HUD and objective HUD when leaving gameplay
	var ui_manager = manager.get_node("../UIManager")
	if ui_manager:
		ui_manager.hide_time_hud()
		ui_manager.hide_objective_hud()

func Update(_delta: float) -> void:
	pass
