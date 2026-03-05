extends Node

var state_stack : Array = []

@onready var ui: Control = $"../UI"
@onready var level_manager: Node = $"../Utilities/LevelManager"
@onready var saver_loader: SaverLoader = %SaverLoader


signal return_to_main_menu_requested
signal state_changed(new_state)

func push_state(state):
	state_stack.push_back(state)
	state.Enter()
	state_changed.emit(state)
	
func pop_state():
	var state = state_stack.pop_back()
	state.Exit()
	if state_stack.size() > 0:
		state_changed.emit(state_stack[-1])
		
func _process(delta):
	process_mode = PROCESS_MODE_ALWAYS
	if state_stack.size() > 0:
		state_stack[-1].Update(delta)
		
func clear_stack():
	while (state_stack.size() > 0):
		pop_state()
		
func save_and_quit():
	return_to_main_menu_requested.emit()
	
func show_ui(scene):
	ui.add_child(scene)
	
func load_level(save):
	level_manager.load_level(save)
	
func free_level():
	level_manager.free_level()

func get_current_level():
	return saver_loader.load_game()
