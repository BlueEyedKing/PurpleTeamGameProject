extends InteractionArea
class_name CleaningStation

## Self-contained cleaning station. Instance cleaning_station.tscn and drag it into any level.
## Launches the brushing minigame when interacted with. One-time use.

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

var _used := false

func _ready() -> void:
	action_name = "Clean Fossil"
	interact = _on_interact

func _on_interact() -> void:
	if _used:
		return

	InteractionManager.lock(self)
	EventBus.minigame_started.emit()

	# Instruction screen
	var instr = INSTRUCTION_SCREEN.instantiate()
	_get_ui_layer().add_child(instr)
	instr.setup(BRUSH_CONFIG)
	await instr.dismissed
	instr.queue_free()

	# Countdown
	var cd = COUNTDOWN_SCREEN.instantiate()
	_get_ui_layer().add_child(cd)
	await cd.start_countdown(3)
	cd.queue_free()

	# Brushing minigame
	var brush = BRUSHING.instantiate()
	_get_ui_layer().add_child(brush)
	var fossil_tex = FOSSIL_TEXTURES[randi() % FOSSIL_TEXTURES.size()]
	brush.start(fossil_tex)
	var brush_result = await brush.brushing_finished
	var clean_pct: float  = brush_result[1]
	var time_left: float  = brush.time_remaining
	brush.queue_free()

	# Result screen
	var result = RESULT_SCREEN.instantiate()
	_get_ui_layer().add_child(result)
	result.show_brush_result(clean_pct, time_left)
	await result.dismissed
	result.queue_free()

	_used = true

	var marker = get_node_or_null("Marker")
	if marker:
		marker.visible = false

	EventBus.minigame_finished.emit()
	GameData.set_flag("cleaning_complete")
	InteractionManager.unlock(self)
	queue_free()

func _get_ui_layer() -> CanvasLayer:
	return get_tree().root.get_node("Main/UI")
