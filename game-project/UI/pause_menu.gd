extends Control

@onready var resume_button: Button   = $CenterContainer/MenuRoot/ResumeButton
@onready var title_button: Button    = $CenterContainer/MenuRoot/TitleButton
@onready var settings_button: Button = $CenterContainer/MenuRoot/SettingsButton
@onready var quit_button: Button     = $CenterContainer/MenuRoot/QuitButton

signal save_and_quit_requested
signal continue_requested

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_button.pressed.connect(_on_resume_pressed)
	title_button.pressed.connect(_on_title_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_resume_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	continue_requested.emit()

func _on_title_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	save_and_quit_requested.emit()

func _on_settings_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	EventBus.settings_requested.emit()

func _on_quit_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	get_tree().quit()
