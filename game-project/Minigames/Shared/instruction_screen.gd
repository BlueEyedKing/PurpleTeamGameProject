extends Control

## Instruction screen shown before a minigame starts.
## Call setup(config) to populate, then await dismissed before proceeding.

signal dismissed

@onready var title_label: Label       = %TitleLabel
@onready var instructions_box: VBoxContainer = %InstructionsBox
@onready var dismiss_label: Label     = %DismissLabel

func _ready() -> void:
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.25)
	_pulse_dismiss_label()

## config keys:
##   "title"        : String
##   "instructions" : Array[Dictionary]  each: {"key": String, "description": String}
##   "dismiss_hint" : String
func setup(config: Dictionary) -> void:
	title_label.text = "~ " + config.get("title", "Instructions") + " ~"
	dismiss_label.text = config.get("dismiss_hint", "Press [E] to Begin")

	for row_data in config.get("instructions", []):
		instructions_box.add_child(_make_row(row_data.get("key", "?"), row_data.get("description", "")))

func _make_row(key_str: String, desc_str: String) -> HBoxContainer:
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 14)

	# Key badge
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.06, 0.04, 1.0)
	style.border_width_left   = 2
	style.border_width_top    = 2
	style.border_width_right  = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.7, 0.5, 0.2, 0.8)
	style.corner_radius_top_left     = 6
	style.corner_radius_top_right    = 6
	style.corner_radius_bottom_right = 6
	style.corner_radius_bottom_left  = 6
	style.content_margin_left   = 10.0
	style.content_margin_right  = 10.0
	style.content_margin_top    = 4.0
	style.content_margin_bottom = 4.0
	panel.add_theme_stylebox_override("panel", style)

	var key_label := Label.new()
	key_label.text = key_str
	key_label.add_theme_font_size_override("font_size", 16)
	key_label.add_theme_color_override("font_color", Color(0.92, 0.87, 0.75))
	key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	key_label.custom_minimum_size = Vector2(46, 0)
	panel.add_child(key_label)

	# Description
	var desc_label := Label.new()
	desc_label.text = desc_str
	desc_label.add_theme_font_size_override("font_size", 16)
	desc_label.add_theme_color_override("font_color", Color(0.75, 0.70, 0.58))
	desc_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	hbox.add_child(panel)
	hbox.add_child(desc_label)
	return hbox

func _pulse_dismiss_label() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(dismiss_label, "modulate:a", 0.35, 0.8)
	tween.tween_property(dismiss_label, "modulate:a", 1.0, 0.8)

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("advance_dialog"):
		get_viewport().set_input_as_handled()
		dismissed.emit()
