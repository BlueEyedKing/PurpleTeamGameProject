extends Node2D

## Dig site level — contains dig spots (QTE) and cleaning stations (Brushing).

const QTE_SEQUENCE = preload("res://Minigames/QTE/qte_sequence.tscn")
const BRUSHING = preload("res://Minigames/Brushing/brushing_minigame.tscn")

const FOSSIL_TEXTURES = [
	preload("res://Sprites/Fossils/Fossil1.png"),
	preload("res://Sprites/Fossils/Fossil2.png"),
	preload("res://Sprites/Fossils/Fossil3.png"),
	preload("res://Sprites/Fossils/Fossil4.png"),
	preload("res://Sprites/Fossils/Fossil5.png"),
	preload("res://Sprites/Fossils/Fossil6.png"),
	preload("res://Sprites/Fossils/Fossil7.png"),
]

const DIG_KEYS = [
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "E", "keyCode": KEY_E},
]

@onready var dig_spot_1: InteractionArea = $DigSpot1
@onready var dig_spot_2: InteractionArea = $DigSpot2
@onready var dig_spot_3: InteractionArea = $DigSpot3
@onready var cleaning_station_1: InteractionArea = $CleaningStation1
@onready var cleaning_station_2: InteractionArea = $CleaningStation2
@onready var cleaning_station_3: InteractionArea = $CleaningStation3

var spots_dug: Array = [false, false, false]
var stations_used: Array = [false, false, false]

## Get the UI CanvasLayer so minigames render in screen-space, not world-space.
func _get_ui_layer() -> CanvasLayer:
	return get_tree().root.get_node("Main/UI")

func _ready() -> void:
	_setup_dig_spot(dig_spot_1, 0)
	_setup_dig_spot(dig_spot_2, 1)
	_setup_dig_spot(dig_spot_3, 2)
	_setup_cleaning_station(cleaning_station_1, 0)
	_setup_cleaning_station(cleaning_station_2, 1)
	_setup_cleaning_station(cleaning_station_3, 2)

func _setup_dig_spot(spot: InteractionArea, index: int) -> void:
	spot.action_name = "Dig"
	spot.interact = Callable(self, "_on_dig_interact").bind(index)

func _setup_cleaning_station(station: InteractionArea, index: int) -> void:
	station.action_name = "Clean Fossil"
	station.interact = Callable(self, "_on_clean_interact").bind(index)

func _on_dig_interact(index: int) -> void:
	if spots_dug[index]:
		return

	EventBus.minigame_started.emit()

	var qte = QTE_SEQUENCE.instantiate()
	_get_ui_layer().add_child(qte)
	qte.start_sequence(DIG_KEYS)
	await qte.sequence_finished
	var success_rate = qte.get_success_rate()
	qte.queue_free()

	spots_dug[index] = true

	# Hide the dig spot marker to show it's been dug
	var marker = get_node_or_null("DigSpot%d/Marker" % (index + 1))
	if marker:
		marker.visible = false

	if success_rate >= 0.5:
		print("Dig spot %d: Success! (%.0f%%)" % [index + 1, success_rate * 100])
	else:
		print("Dig spot %d: Failed. (%.0f%%)" % [index + 1, success_rate * 100])

	EventBus.minigame_finished.emit()

func _on_clean_interact(index: int) -> void:
	if stations_used[index]:
		return

	EventBus.minigame_started.emit()

	var brush = BRUSHING.instantiate()
	_get_ui_layer().add_child(brush)
	var fossil_tex = FOSSIL_TEXTURES[randi() % FOSSIL_TEXTURES.size()]
	brush.start(fossil_tex)
	var results = await brush.brushing_finished
	brush.queue_free()

	stations_used[index] = true

	# Hide the cleaning station marker to show it's been used
	var station_marker = get_node_or_null("CleaningStation%d/Marker" % (index + 1))
	if station_marker:
		station_marker.visible = false

	if results[0]:
		print("Cleaning station %d: Fossil cleaned! (%.0f%%)" % [index + 1, results[1] * 100])
	else:
		print("Cleaning station %d: Time ran out. (%.0f%%)" % [index + 1, results[1] * 100])

	EventBus.minigame_finished.emit()
