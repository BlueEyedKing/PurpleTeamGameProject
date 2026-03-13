extends Node

## GameTheme — Autoload that builds and applies a consistent UI theme.
## Place .ttf font files in res://Resources/Fonts/ for custom fonts.

var theme: Theme

func _ready() -> void:
	theme = Theme.new()
	_setup_fonts()
	_setup_button_styles()
	_setup_label_styles()
	_setup_panel_styles()
	get_tree().root.theme = theme

# -- Fonts ------------------------------------------------------------------

func _setup_fonts() -> void:
	var regular_font = _load_font("res://Resources/Fonts/Cinzel-Regular.ttf")
	var bold_font = _load_font("res://Resources/Fonts/Cinzel-Bold.ttf")
	if regular_font:
		theme.set_default_font(regular_font)
		theme.set_font("font", "Button", regular_font)
		theme.set_font("font", "Label", regular_font)
	if bold_font:
		theme.set_type_variation("BoldLabel", "Label")
		theme.set_font("font", "BoldLabel", bold_font)

func _load_font(path: String):
	# Try loading via ResourceLoader first (works if Godot has imported the file)
	if ResourceLoader.exists(path):
		var font = load(path)
		if font:
			print("[GameTheme] Loaded font: ", path)
			return font
	# Fallback: manually create a FontFile from the raw .ttf data on disk
	if FileAccess.file_exists(path):
		var font = FontFile.new()
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			font.data = file.get_buffer(file.get_length())
			print("[GameTheme] Loaded font from disk: ", path)
			return font
	print("[GameTheme] Font not found: ", path)
	return null

# -- Button Styles -----------------------------------------------------------

func _setup_button_styles() -> void:
	# Normal
	var normal = StyleBoxFlat.new()
	normal.bg_color = Color(0.15, 0.12, 0.08, 0.9)
	normal.border_color = Color(0.7, 0.5, 0.2, 0.6)
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(6)
	normal.set_content_margin_all(12)
	normal.content_margin_left = 24
	normal.content_margin_right = 24
	theme.set_stylebox("normal", "Button", normal)

	# Hover
	var hover = StyleBoxFlat.new()
	hover.bg_color = Color(0.22, 0.18, 0.12, 0.95)
	hover.border_color = Color(0.85, 0.65, 0.3, 0.9)
	hover.set_border_width_all(2)
	hover.set_corner_radius_all(6)
	hover.set_content_margin_all(12)
	hover.content_margin_left = 24
	hover.content_margin_right = 24
	theme.set_stylebox("hover", "Button", hover)

	# Pressed
	var pressed = StyleBoxFlat.new()
	pressed.bg_color = Color(0.1, 0.08, 0.05, 0.95)
	pressed.border_color = Color(0.6, 0.45, 0.2, 0.8)
	pressed.set_border_width_all(1)
	pressed.set_corner_radius_all(6)
	pressed.set_content_margin_all(12)
	pressed.content_margin_left = 24
	pressed.content_margin_right = 24
	theme.set_stylebox("pressed", "Button", pressed)

	# Focus
	var focus = StyleBoxFlat.new()
	focus.bg_color = Color(0.22, 0.18, 0.12, 0.95)
	focus.border_color = Color(0.9, 0.7, 0.35, 1.0)
	focus.set_border_width_all(2)
	focus.set_corner_radius_all(6)
	focus.set_content_margin_all(12)
	focus.content_margin_left = 24
	focus.content_margin_right = 24
	theme.set_stylebox("focus", "Button", focus)

	# Button text colors
	theme.set_color("font_color", "Button", Color(0.92, 0.87, 0.75))
	theme.set_color("font_hover_color", "Button", Color(1.0, 0.95, 0.8))
	theme.set_color("font_pressed_color", "Button", Color(0.75, 0.65, 0.5))
	theme.set_color("font_focus_color", "Button", Color(1.0, 0.95, 0.8))
	theme.set_font_size("font_size", "Button", 20)

# -- Label Styles ------------------------------------------------------------

func _setup_label_styles() -> void:
	theme.set_color("font_color", "Label", Color(0.92, 0.87, 0.75))
	theme.set_font_size("font_size", "Label", 16)

# -- Panel Styles ------------------------------------------------------------

func _setup_panel_styles() -> void:
	var panel = StyleBoxFlat.new()
	panel.bg_color = Color(0.12, 0.1, 0.08, 0.92)
	panel.border_color = Color(0.7, 0.5, 0.2, 0.6)
	panel.set_border_width_all(1)
	panel.set_corner_radius_all(8)
	panel.set_content_margin_all(16)
	theme.set_stylebox("panel", "PanelContainer", panel)
