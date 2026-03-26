extends Node

@onready var state_manager: Node = $Managers/StateManager
@onready var saver_loader: SaverLoader = $Managers/SaverLoader

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	saver_loader.load_settings()
	AudioManager.apply_saved_volumes()
	state_manager.state_changed.connect(_on_state_changed) #debugging purposes
	state_manager.push_state(MainMenuState.new(state_manager))
	AudioManager.play_music(AudioLib.MUSIC["house"])
	
func _on_state_changed(state) -> void:
	print("stack size: ", state_manager.get_stack_size()) #debugging purposes
