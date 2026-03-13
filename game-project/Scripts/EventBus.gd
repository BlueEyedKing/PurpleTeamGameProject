extends Node

signal start_requested()

signal level_load_requested(level: String, gate: String)

#ui
signal pause_menu_show_requested()
signal pause_menu_hide_requested()
signal show_main_menu_requested()
signal free_main_menu_requested()

#actions
signal name_input_done(text: String)
signal inez_leaves(target: Vector2)
