extends Node

@onready var state_manager: Node = $StateManager
@onready var ui: Control = $UI
@onready var saver_loader: Node = %SaverLoader
@onready var ui_manager: Node = $Utilities/UIManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_manager.return_to_main_menu_requested.connect(_on_return_to_main_menu)
	state_manager.state_changed.connect(_on_state_changed)
	state_manager.push_state(MainMenuState.new(state_manager))
	
func _on_return_to_main_menu() -> void:
	saver_loader.save_game()
	state_manager.clear_stack()
	state_manager.push_state(MainMenuState.new(state_manager))
	
func _on_state_changed(state) -> void:
	print("stack size: ", state_manager.state_stack.size()) #debugging purposes
	if state is PauseState:
		ui_manager.show_pause_menu()
	elif state is PlayingState:
		ui_manager.hide_pause_menu()
