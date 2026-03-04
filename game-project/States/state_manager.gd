extends Node

var state_stack : Array = []

@onready var ui: Control = $"../UI"
@onready var saver_loader: Node = %SaverLoader
@onready var level_manager: Node = $"../Utilities/LevelManager"

func push_state(state):
	state_stack.push_back(state)
	state.Enter()
	print("stack size: ", state_stack.size())
func pop_state():
	var state = state_stack.pop_back()
	state.Exit()
func _process(delta):
	if state_stack.size() > 0:
		state_stack[-1].Update(delta)
func clear_stack():
	while (state_stack.size() > 0):
		pop_state()
	state_stack.clear()
func _on_save_and_quit(): # to main menu
	saver_loader.save_game()
	clear_stack()
	var menu = preload("res://UI/main_menu.tscn").instantiate()
	menu.manager = self
	ui.add_child(menu)
	
