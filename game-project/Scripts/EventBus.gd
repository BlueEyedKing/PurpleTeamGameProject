extends Node

signal continue_requested()
signal start_requested()

signal level_load_requested(level: String, gate: String)

signal settings_requested()
#ui
signal pause_menu_show_requested()
signal pause_menu_hide_requested()
signal settings_show_requested()
signal settings_hide_requested()
signal show_main_menu_requested(has_save: bool)
signal free_main_menu_requested()

# Minigame signals
signal minigame_started()
signal minigame_finished()

# Sleep / day cycle
signal sleep_requested()

#actions
signal name_input_done(text: String)
signal inez_leaves(target: Vector2)
signal camila_leaves_requested(target: Vector2)
signal present_fossils_requested()
signal hide_fossils_requested()
signal npc_startled(npc_id: String)
