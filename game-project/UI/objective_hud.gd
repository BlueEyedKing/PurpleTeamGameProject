extends Control

## ObjectiveHUD — Displays a context-sensitive hint about what to do next.
## Reads GameData flags and TimeManager phase; refreshes whenever
## a dialogue ends, the phase changes, or a level transition fires.

@onready var objective_label: Label = $PanelContainer/HBoxContainer/ObjectiveLabel

func _ready() -> void:
	TimeManager.phase_changed.connect(_refresh)
	DialogueUi.dialog_finished.connect(_refresh)
	EventBus.level_load_requested.connect(func(_a, _b): _refresh())
	_refresh()

func _refresh(_a = null, _b = null) -> void:
	objective_label.text = _get_objective()

func _get_objective() -> String:
	var day   := int(GameData.get_value("current_day", 1))
	var phase := TimeManager.current_phase

	if phase == TimeManager.Phase.NIGHT:
		return "Rest for the night."

	if day == 1:
		if GameData.has_flag("day1_town_intro_done"):
			if not GameData.has_flag("day1_tour_complete"):
				if not GameData.has_flag("day1_visited_park"):
					return "Follow Inez to the park."
				if not GameData.has_flag("met_poppy"):
					return "Talk to Poppy."
				if not GameData.has_flag("day1_visited_shop"):
					return "Follow Inez to the shop."
				if not GameData.has_flag("met_aiden"):
					return "Talk to Aiden."
				if not GameData.has_flag("day1_visited_bar"):
					return "Follow Inez to the bar."
				if not GameData.has_flag("met_time_travelers"):
					return "Talk to the group at the bar."
				if not GameData.has_flag("day1_visited_museum"):
					return "Follow Inez to the museum."
				if not GameData.has_flag("met_camila"):
					return "Talk to Camila."
				return "Finish the tour with Inez."
			else:
				return "Head home for the night."
		if not GameData.has_flag("digging_complete"):
			return "Head to the dig site."
		if not GameData.has_flag("cleaning_complete"):
			return "Clean the excavated fossils."
		if not GameData.has_flag("work_done"):
			return "Talk to your boss."
		return "Follow Inez to town."

	if day == 2:
		if not GameData.has_flag("digging_complete"):
			return "Head to the dig site."
		if not GameData.has_flag("cleaning_complete"):
			return "Clean the excavated fossils."
		if not GameData.has_flag("work_done"):
			return "Talk to your boss."
		return "Explore the town."

	return ""
