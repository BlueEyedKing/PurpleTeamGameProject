extends Node2D

const WORK_HUD = preload("res://UI/work_hud.tscn")

@onready var inez: Node2D = $Inez
@onready var digsite: Marker2D = $Digsite

func _ready() -> void:
	EventBus.inez_leaves.connect(func(): inez.walk_to(digsite.global_position))

	# Show the daily task checklist while in camp
	var hud = WORK_HUD.instantiate()
	get_tree().root.get_node("Main/UI/HUD").add_child(hud)
	tree_exiting.connect(hud.queue_free)
	# Hide Inez on Day 2+ — she has no camp role that day.
	var current_day := int(GameData.get_value("current_day", 1))
	if current_day >= 2:
		inez.visible = false
		var ia = inez.get_node_or_null("InteractionArea")
		if ia:
			ia.monitoring = false
			ia.monitorable = false
