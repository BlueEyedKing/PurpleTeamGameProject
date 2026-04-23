extends Node

var state_stack : Array = []
@onready var ui: CanvasLayer = $"../../UI"
@onready var saver_loader: SaverLoader = $"../SaverLoader"
@onready var level_manager: Node = $"../LevelManager"

signal state_changed(new_state) #debugging purposes

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	EventBus.settings_requested.connect(func():
		push_state(SettingsState.new(self)))

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

func save_settings() -> void:
	saver_loader.save_settings()

func get_stack_size() -> int:
	return state_stack.size()

func free_level() -> void:
	level_manager.free_level()
