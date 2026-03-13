extends Node

signal start_requested()

signal level_load_requested(level: String, gate: String)

#ui
signal pause_menu_show_requested()
signal pause_menu_hide_requested()
signal show_main_menu_requested()
signal free_main_menu_requested()

# Minigame signals
signal minigame_started()
signal minigame_finished()

# Sleep / day cycle
signal sleep_requested()
