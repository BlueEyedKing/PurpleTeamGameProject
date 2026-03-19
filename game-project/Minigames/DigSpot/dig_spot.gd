extends InteractionArea
class_name DigSpot

## Self-contained dig spot. Instance dig_spot.tscn and drag it into any level.
## Launches the QTE minigame when interacted with. One-time use.

const QTE_SEQUENCE = preload("res://Minigames/QTE/qte_sequence.tscn")

const DIG_KEYS = [
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "F", "keyCode": KEY_F},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "F", "keyCode": KEY_F},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "F", "keyCode": KEY_F},
]

var _dug := false

func _ready() -> void:
	action_name = "Dig"
	interact = _on_interact

func _on_interact() -> void:
	if _dug:
		return

	InteractionManager.lock(self)
	EventBus.minigame_started.emit()

	var qte = QTE_SEQUENCE.instantiate()
	_get_ui_layer().add_child(qte)
	qte.start_sequence(DIG_KEYS)
	await qte.sequence_finished
	qte.queue_free()

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
