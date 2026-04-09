extends CanvasLayer

@onready var fossil_image: TextureRect = $FossilImage

func _ready() -> void:
	fossil_image.modulate.a = 0.0
	fossil_image.position.y += 20
	EventBus.hide_fossils_requested.connect(_hide)
	_tween_in()

func _tween_in() -> void:
	var tween = create_tween()
	tween.tween_property(fossil_image, "modulate:a", 1.0, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(fossil_image, "position:y", 0.0, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _hide() -> void:
	var tween = create_tween()
	tween.tween_property(fossil_image, "modulate:a", 0.0, 0.5)
	await tween.finished
	queue_free()
