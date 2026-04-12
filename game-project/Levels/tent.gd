extends Node2D

## Tent interior — first-person point-and-click view.
## Contains the fossil cleaning minigame.

const BRUSHING           = preload("res://Minigames/Brushing/brushing_minigame.tscn")
const INSTRUCTION_SCREEN = preload("res://Minigames/Shared/instruction_screen.tscn")
const COUNTDOWN_SCREEN   = preload("res://Minigames/Shared/countdown_screen.tscn")
const RESULT_SCREEN      = preload("res://Minigames/Shared/result_screen.tscn")

const FOSSIL_TEXTURES = [
	preload("res://Resources/Sprites/Fossils/Fossil1.png"),
	preload("res://Resources/Sprites/Fossils/Fossil2.png"),
	preload("res://Resources/Sprites/Fossils/Fossil3.png"),
	preload("res://Resources/Sprites/Fossils/Fossil4.png"),
	preload("res://Resources/Sprites/Fossils/Fossil5.png"),
	preload("res://Resources/Sprites/Fossils/Fossil6.png"),
	preload("res://Resources/Sprites/Fossils/Fossil7.png"),
]

const BRUSH_CONFIG = {
	"title": "Fossil Cleaning",
	"instructions": [
		{"key": "LMB", "description": "Hold and drag to brush away dirt"},
		{"key": "80%", "description": "Reveal this much of the fossil to succeed"},
		{"key": "30s", "description": "Time limit — work quickly!"},
	],
	"dismiss_hint": "Press [E] to Begin"
}

@onready var exit_button: Button  = $CanvasLayer/ExitButton
@onready var clean_button: Button = $CanvasLayer/CleanButton

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)
	clean_button.pressed.connect(_on_clean_pressed)
	if GameData.has_flag("cleaning_complete"):
		clean_button.visible = false

func _on_clean_pressed() -> void:
	clean_button.visible = false
	InteractionManager.lock(self)
	EventBus.minigame_started.emit()

	var instr = INSTRUCTION_SCREEN.instantiate()
	_get_ui_layer().add_child(instr)
	instr.setup(BRUSH_CONFIG)
	await instr.dismissed
	instr.queue_free()

	var cd = COUNTDOWN_SCREEN.instantiate()
	_get_ui_layer().add_child(cd)
	await cd.start_countdown(3)
	cd.queue_free()

	var brush = BRUSHING.instantiate()
	_get_ui_layer().add_child(brush)
	var fossil_tex = FOSSIL_TEXTURES[randi() % FOSSIL_TEXTURES.size()]
	brush.start(fossil_tex)
	var brush_result = await brush.brushing_finished
	var clean_pct: float = brush_result[1]
	var time_left: float = brush.time_remaining
	brush.queue_free()

	var result = RESULT_SCREEN.instantiate()
	_get_ui_layer().add_child(result)
	result.show_brush_result(clean_pct, time_left)
	await result.dismissed
	result.queue_free()

	GameData.set_flag("cleaning_complete")
	EventBus.minigame_finished.emit()
	InteractionManager.unlock(self)

func _on_exit_pressed() -> void:
	EventBus.level_load_requested.emit("camp_1", "TentDoor")

func _get_ui_layer() -> CanvasLayer:
	return get_tree().root.get_node("Main/UI")
