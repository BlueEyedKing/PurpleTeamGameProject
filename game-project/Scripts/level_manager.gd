extends Node

const CAMP_1 = preload("res://Levels/camp_1.tscn")
const MAIN_CITY = preload("res://Levels/main_city.tscn")
@onready var world: Node2D = $"../../World"

var spawn_door
var current_level

func _ready() -> void:
	EventBus.level_load_requested.connect(load_level)

func load_level(level: String, gate: String) -> void:
	if current_level:
		current_level.queue_free()
	match level:
		"camp_1":
			current_level = CAMP_1.instantiate()
		"main_city":
			current_level = MAIN_CITY.instantiate()
	if current_level:
		spawn_door = gate
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
	world.add_child(current_level)
	
	load_player(gate) # TODO move logic?

func free_level() -> void:
	if current_level:
		world.remove_child(current_level)
		current_level.queue_free()
		current_level = null

func load_player(destination_gate: String) -> void:
	var player = preload("res://Player/Player.tscn").instantiate()
	var gate_path = "gate_" + destination_gate
	var gate = current_level.get_node(gate_path) as Gate
	current_level.add_child(player)
	player.global_position = gate.spawn_point.global_position
