extends Control

## TimeHUD — Displays the current day number and time-of-day phase with themed colors.

@onready var day_label: Label = $PanelContainer/VBoxContainer/DayLabel
@onready var phase_label: Label = $PanelContainer/VBoxContainer/PhaseLabel

const PHASE_COLORS = {
	"Morning": Color(1.0, 0.85, 0.5),
	"Daytime": Color(1.0, 0.95, 0.7),
	"Night": Color(0.6, 0.7, 0.9),
}

const PHASE_ICONS = {
	"Morning": "☀ ",
	"Daytime": "⛏ ",
	"Night": "☾ ",
}

func _ready() -> void:
	TimeManager.phase_changed.connect(_on_phase_changed)
	_update_display()

func _on_phase_changed(_phase, _day) -> void:
	_update_display()

func _update_display() -> void:
	day_label.text = "Day %d" % TimeManager.current_day
	var phase_name = TimeManager.get_phase_name()
	var icon = PHASE_ICONS.get(phase_name, "")
	phase_label.text = icon + phase_name
	var color = PHASE_COLORS.get(phase_name, Color(0.92, 0.87, 0.75))
	phase_label.add_theme_color_override("font_color", color)
