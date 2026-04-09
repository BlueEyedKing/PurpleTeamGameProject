extends Node
class_name SaverLoader

const SAVE_PATH = "user://savegame.json"
const SETTINGS_PATH = "user://settings.json"

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		push_error("SaverLoader: could not open save file for writing")
		return
	var data = {
		"flags": GameData.flags,
		"values": GameData.values
	}
	file.store_string(JSON.stringify(data))

func save_settings() -> void:
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if not file:
		push_error("SaverLoader: could not open settings file for writing")
		return
	file.store_string(JSON.stringify(GameData.settings))
	
func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var json = JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	var data = json.data
	GameData.flags = data.get("flags", {})
	GameData.values = data.get("values", {})
	TimeManager.current_day = int(GameData.get_value("current_day", 1))

func load_settings() -> void:
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if not file:
		return
	var json = JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	for key in json.data:
		GameData.settings[key] = json.data[key]

func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
	
func delete_save() -> void:
	DirAccess.remove_absolute(SAVE_PATH)
