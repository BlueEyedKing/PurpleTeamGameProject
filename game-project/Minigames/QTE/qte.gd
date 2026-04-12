extends Control

## Single QTE event — shows a radial countdown and waits for the correct key press.
## Emits finished(success) when the event resolves.

signal finished(success)

@export var keyString: String = "Q"
@export var keyCode: Key = KEY_Q
@export var eventDuration := 0.8
@export var displayDuration := 0.4

@onready var color_rect: ColorRect = %ColorRect
@onready var key_label: Label = %KeyLabel
@onready var result_label: Label = %ResultLabel

var tween: Tween
var success := false
var _resolved := false

func _ready() -> void:
	add_to_group("QTE")
	key_label.text = keyString
	result_label.hide()

	await _animation()

	if not _resolved:
		_resolve(false)

func _animation():
	tween = create_tween()
	tween.tween_property(color_rect, "material:shader_parameter/value", 0, eventDuration)
	await tween.finished

func _resolve(did_succeed: bool) -> void:
	if _resolved:
		return
	_resolved = true
	success = did_succeed

	result_label.show()
	if success:
		result_label.text = "HIT!"
		result_label.add_theme_color_override("font_color", Color(0.3, 1, 0.4))
	else:
		result_label.text = "MISS"
		result_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))

	if tween and tween.is_running():
		tween.kill()

	await get_tree().create_timer(displayDuration).timeout
	finished.emit(success)

func _input(event: InputEvent) -> void:
	if _resolved:
		return
	if Input.is_key_pressed(keyCode):
		_resolve(true)
