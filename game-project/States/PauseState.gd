extends GameState
class_name PauseState


func Enter() -> void:
	EventBus.pause_menu_show_requested.emit()
	manager.get_tree().paused = true
	
func Exit() -> void:
	EventBus.pause_menu_hide_requested.emit()
	manager.get_tree().paused = false
	
func Update(delta) -> void:
	if Input.is_action_just_pressed("pause"):
		manager.pop_state()
