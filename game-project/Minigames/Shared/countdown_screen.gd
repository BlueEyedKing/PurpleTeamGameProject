extends Control

## Countdown screen shown between the instruction screen and the minigame.
## Call start_countdown() and await countdown_finished.

signal countdown_finished

@onready var count_label: Label = %CountLabel

## Counts from `from` down to 1, then shows "GO!", then emits countdown_finished.
func start_countdown(from: int = 3) -> void:
	show()
	for i in range(from, 0, -1):
		count_label.text = str(i)
		_animate_pop()
		await get_tree().create_timer(1.0).timeout
	count_label.text = "GO!"
	_animate_pop()
	await get_tree().create_timer(0.6).timeout
	countdown_finished.emit()

func _animate_pop() -> void:
	count_label.pivot_offset = count_label.size / 2.0
	count_label.scale = Vector2(1.6, 1.6)
	count_label.modulate.a = 1.0
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(count_label, "scale", Vector2(1.0, 1.0), 0.75).set_ease(Tween.EASE_OUT)
	tween.tween_property(count_label, "modulate:a", 0.25, 0.75).set_ease(Tween.EASE_IN)
