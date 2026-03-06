extends GameState
class_name PauseState


func Enter() -> void:
	pass
	
func Exit() -> void:
	pass

func Update(delta) -> void:
	if Input.is_action_just_pressed("pause"):
		manager.pop_state()
