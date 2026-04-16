extends Node2D

## FinalScene — the dig-site confrontation cutscene.
## Loaded by NightState after the Part 1 city thoughts dialogue ends.
## Auto-starts the dig-site dialogue (FinalScenePart2) and emits
## sleep_requested when it finishes, which triggers the credits.

@onready var fade_overlay: ColorRect = $CanvasLayer/FadeOverlay

func _ready() -> void:
	EventBus.fade_to_black_requested.connect(_on_fade_to_black)

	# One frame so the scene and dialogue UI fully settle before we start
	await get_tree().process_frame
	DialogueUi.start_for_npc("FinalScenePart2")
	if AudioLib.MUSIC.has("suspense"):
		AudioManager.play_music(AudioLib.MUSIC["suspense"])
	await DialogueUi.dialog_finished
	EventBus.sleep_requested.emit()


func _on_fade_to_black() -> void:
	var tween := create_tween()
	tween.tween_property(fade_overlay, "color:a", 1.0, 1.2) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
