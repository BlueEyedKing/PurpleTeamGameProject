extends GameState
class_name SettingsState

func Enter() -> void:
	EventBus.settings_show_requested.emit()

func Exit() -> void:
	manager.save_settings()
	EventBus.settings_hide_requested.emit()

func Update(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		manager.pop_state()
