extends Node

@onready var state_manager: Node = $Managers/StateManager
@onready var ui: CanvasLayer = $UI
@onready var saver_loader: SaverLoader = $Managers/SaverLoader
@onready var ui_manager: Node = $Managers/UIManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_manager.state_changed.connect(_on_state_changed)
	state_manager.push_state(MainMenuState.new(state_manager))
	
func _on_state_changed(state) -> void:
	print("stack size: ", state_manager.state_stack.size()) #debugging purposes
	if state is PauseState:
		ui_manager.show_pause_menu()
		get_tree().paused = true
	elif state is PlayingState:
		ui_manager.hide_pause_menu()
		get_tree().paused = false
