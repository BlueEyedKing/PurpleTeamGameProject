extends CanvasLayer

@onready var skull: TextureRect = $skull
@onready var hand: TextureRect = $hand
@onready var ribcage: TextureRect = $ribcage

func _ready() -> void:
	for f in [skull, hand, ribcage]:
		f.modulate.a = 0.0
		#f.scale = Vector2(0.8, 0.8)
	EventBus.hide_fossils_requested.connect(_hide)
	_tween_in()

func _tween_in() -> void:
	var delay = 0.0
	for f in [skull, hand, ribcage]:
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(f, "modulate:a", 1.0, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(delay)
		delay += 0.5

func _hide() -> void:
	var tween = create_tween()
	tween.tween_property(skull, "modulate:a", 0.0, 0.4)
	tween.parallel().tween_property(hand, "modulate:a", 0.0, 0.4)
	tween.parallel().tween_property(ribcage, "modulate:a", 0.0, 0.4)
	await tween.finished
	queue_free()
