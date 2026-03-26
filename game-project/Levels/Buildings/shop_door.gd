extends InteractionArea
class_name ShopDoor

func _ready() -> void:
	action_name = "Enter Shop"
	interact = _on_interact

func _on_interact() -> void:
	var d := GameData
	if d.has_flag("day1_town_intro_done") and not d.has_flag("day1_visited_park"):
		GameData.set_flag("_redirect_park")
		DialogueUi.start_for_npc("Inez")
		return
	EventBus.level_load_requested.emit("shop", "")
