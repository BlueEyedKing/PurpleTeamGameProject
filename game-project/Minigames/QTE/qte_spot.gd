extends InteractionArea
class_name QteSpot

## Self-contained QTE spot. Instance qte_spot.tscn and drag it into any level.
## Launches the Q/F alternating QTE minigame when interacted with.
## Only disappears on a successful run (>= 66% hits).

const QTE_SEQUENCE       = preload("res://Minigames/QTE/qte_sequence.tscn")
const INSTRUCTION_SCREEN = preload("res://Minigames/Shared/instruction_screen.tscn")
const COUNTDOWN_SCREEN   = preload("res://Minigames/Shared/countdown_screen.tscn")
const RESULT_SCREEN      = preload("res://Minigames/Shared/result_screen.tscn")

const QTE_KEYS = [
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "F", "keyCode": KEY_F},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "F", "keyCode": KEY_F},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "F", "keyCode": KEY_F},
]

const QTE_CONFIG = {
	"title": "Excavation",
	"instructions": [
		{"key": "Q", "description": "Press before the timer runs out"},
		{"key": "F", "description": "Alternate with Q — 6 keys total"},
	],
	"dismiss_hint": "Press [E] to Begin"
}

var _shown_instructions := false

func _ready() -> void:
	action_name = "Dig"
	interact = _on_interact
	if GameData.has_flag("digging_complete"):
		queue_free()

func _on_interact() -> void:
	InteractionManager.lock(self)
	EventBus.minigame_started.emit()

	# Instruction screen — first attempt only
	if not _shown_instructions:
		var instr = INSTRUCTION_SCREEN.instantiate()
		_get_ui_layer().add_child(instr)
		instr.setup(QTE_CONFIG)
		await instr.dismissed
		instr.queue_free()
		_shown_instructions = true

	# Countdown
	var cd = COUNTDOWN_SCREEN.instantiate()
	_get_ui_layer().add_child(cd)
	await cd.start_countdown(3)
	cd.queue_free()

	# QTE minigame
	var qte = QTE_SEQUENCE.instantiate()
	_get_ui_layer().add_child(qte)
	qte.start_sequence(QTE_KEYS)
	var results: Array = await qte.sequence_finished
	qte.queue_free()

	# Result screen
	var result = RESULT_SCREEN.instantiate()
	_get_ui_layer().add_child(result)
	result.show_dig_result(results)
	await result.dismissed
	result.queue_free()

	# Check success — matches result_screen threshold
	var hits := results.count(true)
	var pct  := int((float(hits) / float(results.size())) * 100.0) if results.size() > 0 else 0

	InteractionManager.unlock(self)

	if pct < 66:
		return  # Failed — spot stays, player can retry

	# Success — remove spot
	var marker = get_node_or_null("Marker")
	if marker:
		marker.visible = false
	GameData.set_flag("digging_complete")
	EventBus.minigame_finished.emit()
	queue_free()

func _get_ui_layer() -> CanvasLayer:
	return get_tree().root.get_node("Main/UI")
