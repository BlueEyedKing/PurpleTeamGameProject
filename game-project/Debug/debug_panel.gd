extends CanvasLayer

## Debug panel — press F1 to toggle.
## Jumps to any day's night phase with all prerequisite flags pre-set.
## Automatically disabled in non-debug (exported) builds.

var _panel: PanelContainer

# All flags that must be set cumulatively per day.
# Each array ADDS to the previous day's flags.
const FLAGS_BY_DAY: Dictionary = {
	1: [
		# Day 1 daytime — just enough to be at camp with work assigned
	],
	2: [
		"met_boss", "work_done",
		"digging_complete", "cleaning_complete",
		"day1_town_intro_done", "day1_tour_complete",
		"day1_visited_park", "day1_visited_shop", "day1_visited_bar", "day1_visited_museum",
		"met_poppy", "met_aiden", "met_time_travelers", "met_camila",
	],
	3: [
		"day2_talked_inez", "day2_talked_poppy",
		"day2_visited_bar", "camila_day2_submitted",
	],
	4: [
		"met_thea_day3", "met_florence_day3",
		"spoke_to_poppy_and_camila",
	],
	5: [
		"met_aiden_day4_bar", "met_poppy_day4",
		"met_thea_day4", "met_oran_day4",
		"camila_day4_submitted", "camila_day4_showed_radio",
		"met_aiden_day3",
	],
}


func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	layer = 128
	_build_ui()
	_panel.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F1:
			_panel.visible = not _panel.visible
			get_viewport().set_input_as_handled()


func _build_ui() -> void:
	_panel = PanelContainer.new()
	_panel.position = Vector2(20, 20)
	add_child(_panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	_panel.add_child(vbox)

	var title := Label.new()
	title.text = "DEBUG — Jump to Day"
	title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(title)

	for day in range(1, 6):
		var btn := Button.new()
		btn.text = "Day %d  (Night / City)" % day if day > 1 else "Day %d  (Morning / Camp)" % day
		btn.custom_minimum_size = Vector2(260, 40)
		btn.pressed.connect(_jump_to_day.bind(day))
		vbox.add_child(btn)


func _jump_to_day(day: int) -> void:
	_panel.visible = false

	# Clear all existing flags and values, keep settings intact
	GameData.flags.clear()
	GameData.values.clear()
	GameData.set_value("player_name", "Tester")

	# Accumulate all flags up to and including the target day
	for d in range(1, day + 1):
		for flag in FLAGS_BY_DAY.get(d, []):
			GameData.set_flag(flag)

	# Work flags reset each day — set them so the house door doesn't block
	GameData.set_flag("work_done")
	GameData.set_flag("digging_complete")
	GameData.set_flag("cleaning_complete")

	# Set the day
	GameData.set_value("current_day", day)
	TimeManager.current_day = day

	# Find the state manager and warp into the correct phase
	var sm = get_node_or_null("/root/Main/Managers/StateManager")
	if not sm:
		push_error("DebugPanel: Could not find StateManager")
		return

	sm.clear_stack()
	sm.free_level()

	# Day 1 → daytime at camp. All other days → night in the city.
	var playing = PlayingState.new(sm)
	sm.push_state(playing)
	if day == 1:
		sm.push_state(DaytimeState.new(sm))
	else:
		TimeManager.set_phase(TimeManager.Phase.NIGHT)
		sm.push_state(NightState.new(sm))
