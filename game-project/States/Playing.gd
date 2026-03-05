extends GameState
class_name PlayingState

var save = "camp_1" #savefile.current_level

func Enter():
	manager.level_manager.load_level(save)

func Exit():
	manager.level_manager.free_level()
	
func Update(delta):
	if Input.is_action_just_pressed("pause"):
		manager.push_state(PauseState.new(manager))
