extends InteractionArea
class_name CleaningStation

## Self-contained cleaning station. Instance cleaning_station.tscn and drag it into any level.
## Launches the brushing minigame when interacted with. One-time use.

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

var _used := false

func _ready() -> void:
	action_name = "Clean Fossil"
	interact = _on_interact

func _on_interact() -> void:
	if _used:
		return

	InteractionManager.lock(self)
	EventBus.minigame_started.emit()

	var brush = BRUSHING.instantiate()
	_get_ui_layer().add_child(brush)
	var fossil_tex = FOSSIL_TEXTURES[randi() % FOSSIL_TEXTURES.size()]
	brush.start(fossil_tex)
	await brush.brushing_finished
	brush.queue_free()

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
