extends GameState
class_name PlayingState

## PlayingState — Entry point into gameplay.
## Immediately delegates to MorningState to begin the day cycle.
## This keeps PlayingState as the "game is active" marker while
## the day-phase states handle level loading themselves.

func Enter() -> void:
	# Push MorningState on top; PlayingState stays as base of the play stack
	manager.push_state(MorningState.new(manager))

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass
