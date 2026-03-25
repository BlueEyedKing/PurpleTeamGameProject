extends CanvasLayer

@onready var control: Control = $Control
@onready var choices_box: VBoxContainer = $Control/ChoicesBox
@onready var speaker_label: Label = $Control/NinePatchRect/MarginContainer/VBoxContainer/SpeakerLabel
@onready var text_label: Label = $Control/NinePatchRect/MarginContainer/VBoxContainer/TextLabel
@onready var portrait: TextureRect = $Control/NinePatchRect/Portrait

const NAME_INPUT_UI = preload("res://UI/name_input_ui.tscn")
const NORMAL_FONT = preload("res://Resources/superstar_memesbruh03.ttf")
const THOUGHT_FONT = preload("res://Resources/Fonts/smalle.ttf")



var name_input_instance

var dialogue_data: Dictionary = {}
var current_text: String = ""
var current_dialogue_id: String

var typing_speed: float = 0.04
var typing_timer: Timer

var is_typing: bool = false
var waiting_for_input: bool = false

var entry_node_id: String = ""

signal dialog_finished()

func _ready() -> void:
	EventBus.name_input_done.connect(_confirm_name)
	typing_timer = Timer.new()
	typing_timer.one_shot = true
	typing_timer.timeout.connect(_on_typing_timer_timeout)
	add_child(typing_timer)
	hide()

func start_for_npc(npc_id: String) -> void:
	var full_dialogue_data = load_dialogue(npc_id)
	var day_key = "day_%d" % GameData.get_value("current_day", 1)
	var day_data = full_dialogue_data.get(day_key, {})
	if day_data.is_empty():
		push_error("No dialogue for day: " + day_key)
		return
	var start_id = _resolve_entry(day_data)
	if start_id == "":
		push_error("No valid entry found for: " + npc_id)
		return
	_start(day_data, start_id)
	
func load_dialogue(id: String) -> Dictionary:
	var path = "res://Resources/Dialogue/" + id + ".json"
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("DialogueManager: could not open file:" + path)
		return {}
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	if error != OK:
		push_error("DialogueManager: JSON parse error in: " + path)
		return {}
	return json.data

func _start(data: Dictionary, start_id: String) -> void:
	entry_node_id = start_id
	InteractionManager.lock(self)
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_physics_process(false)
	dialogue_data = data
	show()
	_show_dialogue(start_id)
	
func _resolve_entry(data: Dictionary) -> String:
	for id in data:
		var node = data[id]
		if not node.get("entry_point", false):
			continue
		if not _conditions_met(node.get("conditions", {})):
			continue
		return node.get("id","")
	return ""
	 
func _conditions_met(conditions: Dictionary) -> bool:
	for flag in conditions.get("flags_required", []):
		if not GameData.has_flag(flag):
			return false
	for flag in conditions.get("flags_absent", []):
		if GameData.has_flag(flag):
			return false
	var day = conditions.get("day", -1)
	if day != -1 and GameData.get_value("current_day", 1) != day:
		return false
	return true

func _show_dialogue(id: String) -> void:
	if not dialogue_data.has(id):
		push_error("DialogueManager: id '%s' not found:" %id)
		end_dialogue()
		return
		
	current_dialogue_id = id
	var entry = dialogue_data[id]
	var style = entry.get("type", "spoken")
	if style == "thought":
		text_label.add_theme_color_override("font_color", Color(0.7,0.7,1.0))
		text_label.add_theme_font_override("font", THOUGHT_FONT)
	else:
		text_label.add_theme_color_override("font_color", Color(0,0,0,1))
		text_label.add_theme_font_override("font", NORMAL_FONT)

	
	var portrait_id = entry.get("portrait", "")
	if portrait_id:
		portrait.texture = load("res://Resources/Sprites/Portraits/" + portrait_id + ".png")
	var speaker = entry.get("speaker", "")
	if speaker == "Player":
		speaker = GameData.get_value("player_name", "...")
	speaker_label.text = speaker
	current_text = entry.get("text", "...")
	current_text = _substitute_text(entry.get("text", ""))
	
	_clear_choices()
	text_label.text = current_text
	text_label.visible_characters = 0
	
	is_typing = true
	waiting_for_input = false
	typing_timer.start(typing_speed)

func _substitute_text(text: String) -> String:
	text = text.replace("[NAME]", GameData.get_value("player_name", "..."))
	return text

func _on_typing_timer_timeout() -> void:
	var length: int = current_text.length()
	
	if text_label.visible_characters < length:
		text_label.visible_characters += 1
		typing_timer.start(typing_speed)
	else:
		is_typing = false
		_on_typing_done()

func _on_typing_done() -> void:
	var entry: Dictionary = dialogue_data[current_dialogue_id]
	
	match entry.get("action", ""):
		"name_input":
			_show_name_input()
			return
		"inez_leaves":
			EventBus.inez_leaves.emit()
	
	var choices = entry.get("choices", [])
	if choices.size() > 0:
		_show_choices(choices)
	else:
		waiting_for_input = true

func _skip_typing() -> void:
	typing_timer.stop()
	is_typing = false
	text_label.visible_characters = current_text.length()
	_on_typing_done()

func _show_name_input() -> void:
	name_input_instance = NAME_INPUT_UI.instantiate()
	control.add_child(name_input_instance)

func _confirm_name(pname: String) -> void:
	pname = pname.strip_edges()
	if pname == "":
		return
	GameData.set_value("player_name", pname)
	if name_input_instance:
		name_input_instance.queue_free()
		name_input_instance = null
	var next_id = dialogue_data[current_dialogue_id].get("next_id", null)
	if !next_id:
		end_dialogue()
	else:
		_show_dialogue(next_id)

func _show_choices(choices: Array) -> void:
	for choice in choices:
		var button: Button = Button.new()
		button.text = choice.get("text", "???")
		var next_id = choice.get("next_id", null)
		button.pressed.connect(func(): _on_choice_pressed(next_id))
		choices_box.add_child(button)

func _on_choice_pressed(next_id) -> void:
	_clear_choices()
	if next_id == null:
		end_dialogue()
	else:
		_show_dialogue(next_id)
	
func _clear_choices() -> void:
	for child in choices_box.get_children():
		child.queue_free()
		
func end_dialogue() -> void:
	var entry = dialogue_data.get(entry_node_id, {})
	var on_finish = entry.get("on_finish", {})
	for flag in on_finish.get("set_flags", []):
		GameData.set_flag(flag)
	for flag in on_finish.get("remove_flags", []):
		GameData.remove_flag(flag)
	
	InteractionManager.unlock(self)
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_physics_process(true)
	hide()
	dialog_finished.emit()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if not event.is_action_pressed("ui_accept"):
		return
	if is_typing:
		_skip_typing()
	elif waiting_for_input:
		var entry: Dictionary = dialogue_data[current_dialogue_id]
		var next_id = entry.get("next_id", null)
		waiting_for_input = false
		if next_id == null:
			end_dialogue()
		else:
			_show_dialogue(next_id)
	
	get_viewport().set_input_as_handled()
