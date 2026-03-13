extends Node2D


@onready var prompt_panel = $PromptPanel
@onready var label = $PromptPanel/Label

const base_text = "[E] to "

var active_areas = []
var can_interact = true

func _get_player():
	return get_tree().get_first_node_in_group("player")

func register_area(area: InteractionArea):
	active_areas.push_back(area)

func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _process(delta):
	if active_areas.size() > 0 && can_interact && _get_player():
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		prompt_panel.global_position = active_areas[0].global_position
		prompt_panel.global_position.y -= 50
		prompt_panel.global_position.x -= prompt_panel.size.x / 2
		prompt_panel.show()
	else:
		prompt_panel.hide()

func _sort_by_distance_to_player(area1, area2):
	var p = _get_player()
	if not p:
		return false
	var area1_to_player = p.global_position.distance_to(area1.global_position)
	var area2_to_player = p.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			prompt_panel.hide()

			await active_areas[0].interact.call()

			can_interact = true
