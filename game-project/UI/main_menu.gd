extends Control

@onready var start_button: Button = $CenterContainer/MainPanel/VBoxContainer/StartButton
@onready var quit_button: Button = $CenterContainer/MainPanel/VBoxContainer/QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	EventBus.start_requested.emit()
	
func _on_settings_button_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	EventBus.settings_requested.emit()

func _on_quit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
