extends GameState
class_name MainMenuState


func Enter() -> void:
	EventBus.show_main_menu_requested.emit(manager.save_exists())
	EventBus.continue_requested.connect(_on_continue_requested)
	EventBus.start_requested.connect(_on_start_requested)
	
func Exit():
	EventBus.free_main_menu_requested.emit()
	EventBus.continue_requested.disconnect(_on_continue_requested)
	EventBus.start_requested.disconnect(_on_start_requested)
	
func _on_continue_requested():
	manager.clear_stack()
	manager.load_game()
	manager.push_state(PlayingState.new(manager))

func _on_start_requested():
	manager.clear_stack()
	if manager.save_exists():
		manager.delete_save()
	manager.push_state(PlayingState.new(manager))

func Update(_delta: float) -> void:
	pass
