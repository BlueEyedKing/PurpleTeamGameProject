extends Control

## Timing-bar swing minigame for digging.
## Press [E] to stop the needle in a good zone.
## Emits swing_finished(results: Array[bool]) when all swings are done.

signal swing_finished(results: Array)

@export var num_swings: int  = 5
@export var base_speed: float = 0.8  ## Sin cycles per second — increases each swing

@onready var swing_label:    Label     = $CenterContainer/PanelContainer/MarginContainer/VBox/SwingLabel
@onready var feedback_label: Label     = $CenterContainer/PanelContainer/MarginContainer/VBox/FeedbackLabel
@onready var needle:         ColorRect = $CenterContainer/PanelContainer/MarginContainer/VBox/SwingBar/Needle
@onready var needle_arrow:   Label     = $CenterContainer/PanelContainer/MarginContainer/VBox/NeedleArrowWrapper/NeedleArrow

const BAR_WIDTH    := 600.0
const NEEDLE_WIDTH := 4.0
const ARROW_WIDTH  := 20.0

## Zone boundaries as fraction of bar width
const PERFECT_MIN := 0.40
const PERFECT_MAX := 0.60
const GOOD_L_MIN  := 0.30
const GOOD_L_MAX  := 0.40
const GOOD_R_MIN  := 0.60
const GOOD_R_MAX  := 0.70

var _time:          float = 0.0
var _current_swing: int   = 0
var _results:       Array = []
var _waiting:       bool  = false

func _ready() -> void:
	feedback_label.text = ""
	_update_swing_label()

func _process(delta: float) -> void:
	if _waiting:
		return
	_time += delta
	var speed    := base_speed * (1.0 + _current_swing * 0.12)
	var fraction := (sin(_time * speed * PI) + 1.0) / 2.0
	var new_x    := fraction * (BAR_WIDTH - NEEDLE_WIDTH)
	needle.offset_left  = new_x
	needle.offset_right = new_x + NEEDLE_WIDTH
	# Keep ▼ arrow centered over the needle
	needle_arrow.offset_left  = new_x - (ARROW_WIDTH - NEEDLE_WIDTH) * 0.5
	needle_arrow.offset_right = needle_arrow.offset_left + ARROW_WIDTH

func _unhandled_input(event: InputEvent) -> void:
	if _waiting:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("advance_dialog"):
		get_viewport().set_input_as_handled()
		_strike()

func _strike() -> void:
	_waiting = true
	var center   := needle.offset_left + NEEDLE_WIDTH * 0.5
	var fraction := center / BAR_WIDTH
	var hit: bool
	var feedback: String
	var color: Color

	if fraction >= PERFECT_MIN and fraction <= PERFECT_MAX:
		hit      = true
		feedback = "PERFECT!"
		color    = Color(1.0, 0.85, 0.2)
	elif (fraction >= GOOD_L_MIN and fraction < GOOD_L_MAX) or \
		 (fraction > GOOD_R_MIN and fraction <= GOOD_R_MAX):
		hit      = true
		feedback = "GOOD!"
		color    = Color(0.35, 0.9, 0.45)
	else:
		hit      = false
		feedback = "MISS!"
		color    = Color(0.95, 0.3, 0.3)

	_results.append(hit)
	feedback_label.text = feedback
	feedback_label.add_theme_color_override("font_color", color)
	_animate_feedback(hit)

	await get_tree().create_timer(0.55).timeout

	_current_swing += 1
	feedback_label.text  = ""
	feedback_label.scale = Vector2.ONE

	if _current_swing >= num_swings:
		swing_finished.emit(_results)
	else:
		_update_swing_label()
		_waiting = false

func _animate_feedback(hit: bool) -> void:
	# Wait one frame so the label has laid out and size is correct
	await get_tree().process_frame
	feedback_label.pivot_offset = feedback_label.size / 2.0

	if hit:
		# Punch scale in — bigger for PERFECT
		var target := Vector2(1.35, 1.35) if _results.back() == true and \
			(needle.offset_left + NEEDLE_WIDTH * 0.5) / BAR_WIDTH >= PERFECT_MIN and \
			(needle.offset_left + NEEDLE_WIDTH * 0.5) / BAR_WIDTH <= PERFECT_MAX \
			else Vector2(1.15, 1.15)
		feedback_label.scale = Vector2(0.4, 0.4)
		var tw := create_tween()
		tw.tween_property(feedback_label, "scale", target, 0.12) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.tween_property(feedback_label, "scale", Vector2.ONE, 0.1)
	else:
		# Shake horizontally
		feedback_label.scale = Vector2.ONE
		var tw := create_tween()
		tw.tween_property(feedback_label, "pivot_offset:x", feedback_label.pivot_offset.x - 10, 0.05)
		tw.tween_property(feedback_label, "pivot_offset:x", feedback_label.pivot_offset.x + 10, 0.05)
		tw.tween_property(feedback_label, "pivot_offset:x", feedback_label.pivot_offset.x - 6,  0.04)
		tw.tween_property(feedback_label, "pivot_offset:x", feedback_label.pivot_offset.x,       0.04)

func _update_swing_label() -> void:
	swing_label.text = "SWING  %d / %d" % [_current_swing + 1, num_swings]
