extends Node

var state_stack : Array = []
@onready var ui: CanvasLayer = $"../../UI"
@onready var saver_loader: SaverLoader = $"../SaverLoader"
@onready var level_manager: Node = $"../LevelManager"


#signal return_to_main_menu_requested
signal state_changed(new_state)

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	
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
	if state_stack.size() > 0:
		state_stack[-1].Update(delta)
		
func clear_stack() -> void:
	while (state_stack.size() > 0):
		pop_state()
		
func save_and_quit() -> void:
	saver_loader.save_game()
	clear_stack()
	push_state(MainMenuState.new(self))
	
func show_ui(scene) -> void:
	ui.add_child(scene)
	
func load_level(save) -> void:
	level_manager.load_level(save[0], save[1])
	
func free_level() -> void:
	level_manager.free_level()

func get_current_level(): # at least currently returns a hardcoded array for testing purposes
	return saver_loader.load_game()
