extends Control

@onready var continue_button: Button = $CenterContainer/MainPanel/VBoxContainer/ContinueButton
@onready var quit_button: Button = $CenterContainer/MainPanel/VBoxContainer/QuitButton

signal save_and_quit_requested
signal continue_requested

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #PROCESS_MODE_WHEN_PAUSED
	continue_button.pressed.connect(_on_continue_pressed)
	quit_button.pressed.connect(_on_save_and_quit_pressed)
	
func _on_continue_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	continue_requested.emit()
	
func _on_settings_button_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	EventBus.settings_requested.emit()
	
func _on_save_and_quit_pressed() -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	save_and_quit_requested.emit()
