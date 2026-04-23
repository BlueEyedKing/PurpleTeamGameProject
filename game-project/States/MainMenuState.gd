extends GameState
class_name MainMenuState

func Enter() -> void:
	EventBus.show_main_menu_requested.emit(false)
	EventBus.start_requested.connect(_on_start_requested)

func Exit():
	EventBus.free_main_menu_requested.emit()
	EventBus.start_requested.disconnect(_on_start_requested)

func _on_start_requested():
	GameData.flags.clear()
	GameData.values.clear()
	manager.clear_stack()
	manager.push_state(PlayingState.new(manager))

func Update(_delta: float) -> void:
	pass
