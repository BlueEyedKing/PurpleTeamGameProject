extends Node

@onready var state_manager: Node = $Managers/StateManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_manager.state_changed.connect(_on_state_changed) #debugging purposes
	state_manager.push_state(MainMenuState.new(state_manager))
	AudioManager.play_music(AudioLib.MUSIC["main"])
	
func _on_state_changed(state) -> void:
	print("stack size: ", state_manager.state_stack.size()) #debugging purposes
