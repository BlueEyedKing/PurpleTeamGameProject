extends GameState
class_name PlayingState


func Enter() -> void:
	manager.load_level(manager.get_current_level())

func Exit() -> void:
	manager.free_level()
	
func Update(delta) -> void:
	if Input.is_action_just_pressed("pause"):
		manager.push_state(PauseState.new(manager))
