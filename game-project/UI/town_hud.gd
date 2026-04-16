extends Control

## TownHUD — Shows the player's evening objectives while in the city.
## Instantiated by main_city.gd and lives only while main_city is loaded.

@onready var vbox: VBoxContainer = $PanelContainer/VBoxContainer

const COLOR_DONE = Color(0.45, 0.85, 0.45)
const COLOR_TODO = Color(0.92, 0.87, 0.75)

# [display text, flag that marks it complete]
const OBJECTIVES: Dictionary = {
	1: [
		["Visit the park",    "day1_visited_park"],
		["Visit the shop",    "day1_visited_shop"],
		["Visit the bar",     "day1_visited_bar"],
		["Visit the museum",  "day1_visited_museum"],
	],
	2: [
		["Talk to Inez",              "day2_talked_inez"],
		["Talk to Poppy",             "day2_talked_poppy"],
		["Visit the bar",             "day2_visited_bar"],
		["Submit fossils to Camila",  "camila_day2_submitted"],
	],
	3: [
		["Talk to Poppy",  "spoke_to_poppy_and_camila"],
		["Talk to Thea",   "met_thea_day3"],
		["Visit the bar",  "met_florence_day3"],
		["Talk to Aiden",  "met_aiden_day3"],
	],
	4: [
		["Talk to Poppy",  "met_poppy_day4"],
		["Talk to Thea",   "met_thea_day4"],
		["Visit the bar",  "met_aiden_day4_bar"],
		["Talk to Camila", "camila_day4_submitted"],
	],
	5: [
		["Talk to Aiden",             "met_aiden_day5"],
		["Submit fossils to Camila",  "camila_day5_submitted"],
	],
}

var _rows: Array[Label] = []

func _ready() -> void:
	var day: int = GameData.get_value("current_day", 1)
	var day_objectives: Array = OBJECTIVES.get(day, [])

	# Build a label row for each objective
	for obj in day_objectives:
		var label := Label.new()
		label.add_theme_font_size_override("font_size", 15)
		vbox.add_child(label)
		_rows.append(label)

	# Hide entirely if there are no objectives for this day
	if _rows.is_empty():
		visible = false
		return

	DialogueUi.dialog_finished.connect(_refresh)
	_refresh()


func _refresh(_ignored = null) -> void:
	var day: int = GameData.get_value("current_day", 1)
	var day_objectives: Array = OBJECTIVES.get(day, [])

	for i in _rows.size():
		var task: String  = day_objectives[i][0]
		var flag: String  = day_objectives[i][1]
		var done: bool    = GameData.has_flag(flag)
		_rows[i].text = ("✓  " if done else "◻  ") + task
		_rows[i].add_theme_color_override("font_color", COLOR_DONE if done else COLOR_TODO)
