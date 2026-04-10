extends Control

## WorkHUD — Shows the player's daily task checklist at the dig site.
## Instantiated by camp_1.gd and lives only while camp_1 is loaded.

@onready var dig_row:   Label = $PanelContainer/VBoxContainer/DigRow
@onready var clean_row: Label = $PanelContainer/VBoxContainer/CleanRow
@onready var boss_row:  Label = $PanelContainer/VBoxContainer/BossRow

const COLOR_DONE = Color(0.45, 0.85, 0.45)
const COLOR_TODO = Color(0.92, 0.87, 0.75)

func _ready() -> void:
	EventBus.minigame_finished.connect(_refresh)
	DialogueUi.dialog_finished.connect(_refresh)
	_refresh()

func _refresh(_ignored = null) -> void:
	_set_row(dig_row,   "Excavate Fossil", GameData.has_flag("digging_complete"))
	_set_row(clean_row, "Clean Fossil",    GameData.has_flag("cleaning_complete"))
	_set_row(boss_row,  "Report to Boss",  GameData.has_flag("work_done"))

func _set_row(label: Label, task: String, done: bool) -> void:
	label.text = ("✓  " if done else "◻  ") + task
	label.add_theme_color_override("font_color", COLOR_DONE if done else COLOR_TODO)
