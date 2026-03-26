extends InteractionArea
class_name DigSpot

## Self-contained dig spot. Instance dig_spot.tscn and drag it into any level.
## Launches the QTE minigame when interacted with. One-time use.

const QTE_SEQUENCE       = preload("res://Minigames/QTE/qte_sequence.tscn")
const INSTRUCTION_SCREEN = preload("res://Minigames/Shared/instruction_screen.tscn")
const COUNTDOWN_SCREEN   = preload("res://Minigames/Shared/countdown_screen.tscn")
const RESULT_SCREEN      = preload("res://Minigames/Shared/result_screen.tscn")

const DIG_KEYS = [
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "F", "keyCode": KEY_F},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "F", "keyCode": KEY_F},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "F", "keyCode": KEY_F},
]

const DIG_CONFIG = {
	"title": "Excavation",
	"instructions": [
		{"key": "Q", "description": "Press before the timer runs out"},
		{"key": "F", "description": "Alternate with Q — 6 keys total"},
	],
	"dismiss_hint": "Press [E] to Begin"
}

var _dug := false

func _ready() -> void:
	action_name = "Dig"
	interact = _on_interact

func _on_interact() -> void:
	if _dug:
		return

	InteractionManager.lock(self)
	EventBus.minigame_started.emit()

	# Instruction screen
	var instr = INSTRUCTION_SCREEN.instantiate()
	_get_ui_layer().add_child(instr)
	instr.setup(DIG_CONFIG)
	await instr.dismissed
	instr.queue_free()

	# Countdown
	var cd = COUNTDOWN_SCREEN.instantiate()
	_get_ui_layer().add_child(cd)
	await cd.start_countdown(3)
	cd.queue_free()

	# QTE minigame
	var qte = QTE_SEQUENCE.instantiate()
	_get_ui_layer().add_child(qte)
	qte.start_sequence(DIG_KEYS)
	var results: Array = await qte.sequence_finished
	qte.queue_free()

	# Result screen
	var result = RESULT_SCREEN.instantiate()
	_get_ui_layer().add_child(result)
	result.show_dig_result(results)
	await result.dismissed
	result.queue_free()

	_dug = true

	var marker = get_node_or_null("Marker")
	if marker:
		marker.visible = false

	EventBus.minigame_finished.emit()
	GameData.set_flag("digging_complete")
	InteractionManager.unlock(self)
	queue_free()

func _get_ui_layer() -> CanvasLayer:
	return get_tree().root.get_node("Main/UI")
