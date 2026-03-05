extends GameState
class_name PauseState


func Enter():
	pass
	
func Exit():
	pass

func Update(delta):
	if Input.is_action_just_pressed("pause"):
		manager.pop_state()
