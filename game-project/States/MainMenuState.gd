extends GameState
class_name MainMenuState

var menu

func Enter():
	menu = preload("res://UI/main_menu.tscn").instantiate()
	menu.start_requested.connect(func():
		manager.clear_stack()
		manager.push_state(PlayingState.new(manager))
		)
	manager.show_ui(menu)
	
func Exit():
	if (menu):
		menu.queue_free()

#func Update(delta):
	#if Input.is_action_just_pressed("pause"):
		#manager.pop_state()
