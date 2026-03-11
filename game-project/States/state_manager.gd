extends Node

var state_stack : Array = []
@onready var ui: CanvasLayer = $"../../UI"
@onready var saver_loader: SaverLoader = $"../SaverLoader"
@onready var level_manager: Node = $"../LevelManager"


#signal return_to_main_menu_requested
signal state_changed(new_state)

func push_state(state) -> void:
	state_stack.push_back(state)
	state.Enter()
	state_changed.emit(state)
	
func pop_state() -> void:
	var state = state_stack.pop_back()
	state.Exit()
	if state_stack.size() > 0:
		state_changed.emit(state_stack[-1])
		
func _process(delta) -> void:
	process_mode = PROCESS_MODE_ALWAYS
	if state_stack.size() > 0:
		state_stack[-1].Update(delta)
		
func clear_stack() -> void:
	while (state_stack.size() > 0):
		pop_state()
		
func save_and_quit() -> void:
	saver_loader.save_game()
	clear_stack()
	push_state(MainMenuState.new(self))
	#return_to_main_menu_requested.emit()
	
func show_ui(scene) -> void:
	ui.add_child(scene)
	
func load_level(save) -> void:
	level_manager.load_level(save)
	
func free_level() -> void:
	level_manager.free_level()

func get_current_level() -> String: # at least currently returns a hardcoded string for testing purposes
	return saver_loader.load_game()
