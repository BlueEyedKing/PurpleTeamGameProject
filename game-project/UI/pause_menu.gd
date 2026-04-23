extends Control

@onready var resume_button: Button   = $CenterContainer/MainPanel/VBoxContainer/ResumeButton
@onready var settings_button: Button = $CenterContainer/MainPanel/VBoxContainer/SettingsButton
@onready var quit_button: Button     = $CenterContainer/MainPanel/VBoxContainer/QuitButton

signal continue_requested

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_resume_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	continue_requested.emit()

func _on_settings_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	EventBus.settings_requested.emit()

func _on_quit_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	get_tree().quit()
