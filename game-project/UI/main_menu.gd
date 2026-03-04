extends Control

@onready var start_button = $VBoxContainer/NinePatchRect/StartButton
@onready var quit_button: Button = $VBoxContainer/NinePatchRect3/QuitButton

var manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(Callable(self, "_on_start_pressed"))
	quit_button.pressed.connect(Callable(self, "_on_quit_pressed"))
func _on_start_pressed():
	manager.push_state(PlayingState.new(manager))
	queue_free()

func _on_quit_pressed():
	#manager.clear_stack() ?
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
