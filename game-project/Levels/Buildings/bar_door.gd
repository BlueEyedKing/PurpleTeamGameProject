extends InteractionArea
class_name BarDoor

func _ready() -> void:
	action_name = "Enter Bar"
	interact = _on_interact

func _on_interact() -> void:
	var d := GameData
	if d.has_flag("day1_town_intro_done") and not d.has_flag("day1_visited_park"):
		GameData.set_flag("_redirect_park")
		DialogueUi.start_for_npc("Inez")
		return
	if d.has_flag("day1_visited_park") and not d.has_flag("day1_visited_shop"):
		GameData.set_flag("_redirect_shop")
		DialogueUi.start_for_npc("Inez")
		return
	EventBus.level_load_requested.emit("bar", "")
