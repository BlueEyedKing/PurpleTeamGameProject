extends GameState
class_name PauseState

var pause_menu

func Enter():
	print("paused")
	#get_tree().paused = true no work why?
	pause_menu = preload("res://UI/pause_menu.tscn").instantiate()
	pause_menu.manager = manager
	pause_menu.save_and_quit_requested.connect(manager._on_save_and_quit)
	manager.ui.add_child(pause_menu)
	
func Exit():
	print("unpaused")
	#get_tree().paused = false no work why?
	if (pause_menu):
		pause_menu.queue_free()

func Update(delta):
	if Input.is_action_just_pressed("pause"):
		manager.pop_state()
