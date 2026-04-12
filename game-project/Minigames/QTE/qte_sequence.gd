extends Control

## QTE Sequence Manager — spawns a series of QTE events one at a time.
## Call start_sequence() with a custom key list.
## Emits sequence_finished(results) when all events are done.

signal sequence_finished(results: Array)

const QTE = preload("res://Minigames/QTE/qte.tscn")

@onready var qte_container: CenterContainer = $MainPanel/VBox/QTEContainer

var key_list: Array = []
var results: Array = []

## Start the QTE sequence with a custom key list.
## Each entry: {"keyString": "Q", "keyCode": KEY_Q}
func start_sequence(keys: Array) -> void:
	key_list = keys
	results = []
	_run_sequence()

func _run_sequence() -> void:
	for i in key_list.size():
		# Clear previous QTE
		for child in qte_container.get_children():
			child.queue_free()

		# Small pause between QTEs
		if i > 0:
			await get_tree().create_timer(0.3).timeout

		# Spawn and wait for this QTE to fully resolve
		var key_node = QTE.instantiate()
		key_node.keyCode = key_list[i].keyCode
		key_node.keyString = key_list[i].keyString
		qte_container.add_child(key_node)

		var success = await key_node.finished
		results.append(success)

	# All done
	sequence_finished.emit(results)

func get_success_rate() -> float:
	if results.size() == 0:
		return 0.0
	return results.count(true) / float(results.size())
