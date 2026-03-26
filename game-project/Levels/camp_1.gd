extends Node2D

@onready var inez: Node2D = $Inez
@onready var digsite: Marker2D = $Digsite

func _ready() -> void:
	EventBus.inez_leaves.connect(func(): inez.walk_to(digsite.global_position))
	# Hide Inez on Day 2+ — she has no camp role that day.
	var current_day := int(GameData.get_value("current_day", 1))
	if current_day >= 2:
		inez.visible = false
		var ia = inez.get_node_or_null("InteractionArea")
		if ia:
			ia.monitoring = false
			ia.monitorable = false
