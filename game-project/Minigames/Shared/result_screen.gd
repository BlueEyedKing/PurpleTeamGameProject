extends Control

## Result screen shown after a minigame completes.
## Call show_dig_result() or show_brush_result(), then await dismissed.

signal dismissed

@onready var title_label:  Label = %TitleLabel
@onready var rating_label: Label = %RatingLabel
@onready var stat_label:   Label = %StatLabel
@onready var dismiss_label: Label = %DismissLabel

# ── Public API ────────────────────────────────────────────────────────────────

func show_dig_result(results: Array) -> void:
	var hits  := results.count(true)
	var total := results.size()
	var pct   := int((float(hits) / float(total)) * 100.0) if total > 0 else 0
	title_label.text = "Excavation Complete"
	stat_label.text  = "%d / %d Keys Hit  (%d%%)" % [hits, total, pct]
	_apply_rating(pct)
	_show_animated()

func show_brush_result(clean_pct: float, time_remaining: float) -> void:
	var pct := int(clean_pct * 100.0)
	title_label.text = "Fossil Cleaned"
	stat_label.text  = "%d%% Revealed" % pct
	if time_remaining > 0.5:
		stat_label.text += "\n%.1f sec remaining" % time_remaining
	_apply_rating(pct)
	_show_animated()

# ── Internal ──────────────────────────────────────────────────────────────────

func _apply_rating(pct: int) -> void:
	if pct == 100:
		rating_label.text = "Perfect!"
		rating_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
	elif pct >= 66:
		rating_label.text = "Good Job!"
		rating_label.add_theme_color_override("font_color", Color(0.35, 0.9, 0.45))
	else:
		rating_label.text = "Keep Practicing!"
		rating_label.add_theme_color_override("font_color", Color(0.95, 0.55, 0.25))

func _show_animated() -> void:
	show()
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	_pulse_dismiss_label()

func _pulse_dismiss_label() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(dismiss_label, "modulate:a", 0.35, 0.9)
	tween.tween_property(dismiss_label, "modulate:a", 1.0, 0.9)

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("advance_dialog"):
		get_viewport().set_input_as_handled()
		dismissed.emit()
