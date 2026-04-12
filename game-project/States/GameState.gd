extends Node
class_name GameState

var manager

func _init(_manager):
	manager = _manager

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	if Input.is_action_just_pressed("pause") and not DialogueUi.visible:
		manager.push_state(PauseState.new(manager))
