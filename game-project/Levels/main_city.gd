extends Node2D

const TOWN_HUD = preload("res://UI/town_hud.tscn")

@onready var _inez: Node = $Inez


@onready var _pos_park:     Marker2D = $InezPark
@onready var _pos_shop:     Marker2D = $InezShop
@onready var _pos_bar:      Marker2D = $InezBar
@onready var _pos_museum:   Marker2D = $InezMuseum
@onready var _pos_farewell: Marker2D = $InezFarewell

@onready var _poppy = $Poppy
@onready var camila: Node2D = $Camila


var _inez_current_target: Vector2 = Vector2.INF

func _ready() -> void:
	EventBus.camila_leaves_requested.connect(transition_things)
	_inez.walk_speed = 290.0

	if GameData.has_flag("day1_town_intro_done") and not GameData.has_flag("day1_tour_complete"):
		var saved: Vector2 = GameData.get_value("inez_pos", Vector2.INF)
		if saved != Vector2.INF:
			_inez.global_position = saved
			_inez_current_target  = saved

	# Hide Camila after she leaves on Day 1 (goes into museum) or Day 3 (after Poppy scene)
	if GameData.has_flag("met_poppy_and_camila") or GameData.has_flag("spoke_to_poppy_and_camila"):
		_set_npc_active(camila, false)
		camila.modulate.a = 0.0

	tree_exiting.connect(_save_inez_pos)

	# Mount the evening objectives HUD (freed automatically when the level unloads)
	var hud = TOWN_HUD.instantiate()
	get_tree().root.get_node("Main/UI/HUD").add_child(hud)
	tree_exiting.connect(hud.queue_free)

	DialogueUi.dialog_finished.connect(_update_tour_npcs)
	_update_tour_npcs()


func _save_inez_pos() -> void:
	if _inez.visible:
		GameData.set_value("inez_pos", _inez.global_position)

func _update_tour_npcs() -> void:

	GameData.remove_flag("_redirect_park")
	GameData.remove_flag("_redirect_shop")
	GameData.remove_flag("_redirect_bar")

	var d := GameData
	var tour_done := d.has_flag("day1_tour_complete")
	var current_day: int = GameData.get_value("current_day", 1)

	if current_day >= 2:

		_set_npc_active(_inez, true)
		_inez_current_target = _inez.global_position
	else:
		_set_npc_active(_inez, not tour_done)
		if not tour_done and d.has_flag("day1_town_intro_done"):
			var next_pos := _next_inez_waypoint()
			if not next_pos.is_equal_approx(_inez_current_target):
				_inez_current_target = next_pos
				_walk_inez_to(next_pos)

	var poppy_visible: bool = current_day != 5
	_set_npc_active(_poppy, poppy_visible)

	# Day 3 — fade Camila out once the Poppy/Camila dialogue has fully closed
	if current_day == 3 and GameData.has_flag("spoke_to_poppy_and_camila") and camila.visible:
		transition_things()


func _next_inez_waypoint() -> Vector2:
	var d := GameData

	if not d.has_flag("day1_visited_park") or not d.has_flag("met_poppy"):
		return _pos_park.global_position

	if not d.has_flag("day1_visited_shop") or not d.has_flag("met_aiden"):
		return _pos_shop.global_position

	if not d.has_flag("day1_visited_bar") or not d.has_flag("met_time_travelers"):
		return _pos_bar.global_position

	if not d.has_flag("day1_visited_museum") or not d.has_flag("met_camila"):
		return _pos_museum.global_position
	return _pos_farewell.global_position

func _walk_inez_to(pos: Vector2) -> void:
	await _inez.walk_to(pos)
	GameData.set_value("inez_pos", pos)

func _set_npc_active(npc: Node, active: bool) -> void:
	npc.visible = active
	var ia = npc.get_node_or_null("InteractionArea")
	if ia:
		ia.monitoring = active
		ia.monitorable = active

func transition_things():
	_set_npc_active(camila, false)
	var tween = create_tween()
	tween.tween_property(camila, "modulate:a", 0.0, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	camila.visible = false
