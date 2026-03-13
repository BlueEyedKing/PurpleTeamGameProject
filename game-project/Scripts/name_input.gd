extends Control

@onready var line_edit: LineEdit = $LineEdit


func _ready():
	line_edit.text_submitted.connect(_on_line_edit_text_entered)
	
func _on_line_edit_text_entered(text: String) -> void:
	EventBus.name_input_done.emit(line_edit.text)
