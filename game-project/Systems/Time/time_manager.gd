extends Node

## TimeManager — Tracks the current day and time-of-day phase.
## Provides a CanvasModulate node for color tinting per phase.

signal phase_changed(phase, day)

enum Phase { MORNING, DAYTIME, NIGHT }

const TINT_MORNING = Color(1.1, 1.0, 0.85)
const TINT_DAYTIME = Color(1.0, 1.0, 1.0)
const TINT_NIGHT   = Color(0.4, 0.4, 0.7)

var current_day: int = 1
var current_phase: Phase = Phase.MORNING
var canvas_modulate: CanvasModulate

func _ready() -> void:
	canvas_modulate = CanvasModulate.new()
	add_child(canvas_modulate)
	set_phase(Phase.MORNING)

func set_phase(phase: Phase) -> void:
	current_phase = phase
	match phase:
		Phase.MORNING:
			canvas_modulate.color = TINT_MORNING
		Phase.DAYTIME:
			canvas_modulate.color = TINT_DAYTIME
		Phase.NIGHT:
			canvas_modulate.color = TINT_NIGHT
	phase_changed.emit(current_phase, current_day)

func advance_day() -> void:
	current_day += 1
	print("Day %d begins" % current_day)
	phase_changed.emit(current_phase, current_day)

func get_phase_name() -> String:
	match current_phase:
		Phase.MORNING: return "Morning"
		Phase.DAYTIME: return "Daytime"
		Phase.NIGHT: return "Night"
	return ""
