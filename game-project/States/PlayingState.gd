extends GameState
class_name PlayingState


func Enter() -> void:
	EventBus.level_load_requested.emit("main_city", "camp_1")

func Exit() -> void:
	manager.free_level()
	
func Update(delta) -> void:
	if Input.is_action_just_pressed("pause"):
		manager.push_state(PauseState.new(manager))
