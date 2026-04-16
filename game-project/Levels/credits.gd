extends Node2D

@onready var return_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/ReturnButton

func _ready() -> void:
	return_button.pressed.connect(_on_return_pressed)

func _on_return_pressed() -> void:
	get_tree().quit()
