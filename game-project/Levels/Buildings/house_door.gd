extends InteractionArea
class_name HouseDoor

const LINES_TOUR: Array[String] = [
	"I should see the rest of town before heading home.",
	"Inez is still waiting for me."
]
const LINES_WORK: Array[String] = [
	"I still have work to finish.",
	"I can't go home yet."
]
const LINES_PEOPLE: Array[String] = [
	"There are still people I should talk to.",
	"I can't go home just yet."
]

func _ready() -> void:
	action_name = "Enter House"
	interact = _on_interact

func _on_interact() -> void:
	var day: int = GameData.get_value("current_day", 1)
	var lines: Array[String] = []

	if day == 1 and not GameData.has_flag("day1_tour_complete"):
		lines = LINES_TOUR
	elif day == 2 and not GameData.has_flag("work_done"):
		lines = LINES_WORK
	elif day == 2 and not (
		GameData.has_flag("day2_talked_inez") and
		GameData.has_flag("day2_talked_poppy") and
		GameData.has_flag("day2_visited_bar") and
		GameData.has_flag("camila_day2_submitted")
	):
		lines = LINES_PEOPLE
	elif day == 5 and not GameData.has_flag("work_done"):
		lines = LINES_WORK
	elif day == 5 and not GameData.has_flag("final_scene_done") \
		and GameData.has_flag("met_aiden_day5") \
		and GameData.has_flag("camila_day5_submitted"):
		# Player has done everything — fade to black then roll the finale
		await _trigger_final_scene()
		return
	elif day == 5 and not GameData.has_flag("final_scene_done"):
		lines = LINES_PEOPLE
	elif day >= 3 and not GameData.has_flag("work_done"):
		lines = LINES_WORK

	if not lines.is_empty():
		InteractionManager.lock(self)
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.set_physics_process(false)
		InfoBubble.start_text(global_position, lines)
		await InfoBubble.text_finished
		InteractionManager.unlock(self)
		player = get_tree().get_first_node_in_group("player")
		if player:
			player.set_physics_process(true)
		return

	EventBus.level_load_requested.emit("house", "")


func _trigger_final_scene() -> void:
	# Fade to black
	var transition = preload("res://MiscObjects/transition_screen.tscn").instantiate()
	get_tree().root.add_child(transition)
	transition.transition()
	await transition.on_transition_finished

	# Start dialogue while fading back in
	DialogueUi.start_for_npc("FinalScene")
	await transition.animation_player.animation_finished
	transition.queue_free()

	# Wait for the city thoughts to finish then transition to the dig site
	await DialogueUi.dialog_finished
	EventBus.level_load_requested.emit("final_scene", "")
