extends GameState
class_name PlayingState


func Enter():
	manager.load_level(manager.get_current_level())

func Exit():
	manager.free_level()
	
func Update(delta):
	if Input.is_action_just_pressed("pause"):
		manager.push_state(PauseState.new(manager))
