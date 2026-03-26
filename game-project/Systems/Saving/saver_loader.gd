extends Node
class_name SaverLoader

const SAVE_PATH = "user://savegame.json"
const SETTINGS_PATH = "user://settings.json"

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		"flags": GameData.flags,
		"values": GameData.values
	}
	file.store_string(JSON.stringify(data))

func save_settings() -> void:
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	var data = {
		"volume_master": GameData.get_value("volume_master", 0.5),
		"volume_music": GameData.get_value("volume_music", 0.5),
		"volume_ambiance": GameData.get_value("volume_ambiance", 0.5),
		"volume_sfx": GameData.get_value("volume_sfx", 0.5),
		"mute_master": GameData.get_value("mute_master", false)
	}
	file.store_string(JSON.stringify(data))
	
func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if !file:
		return
	var json = JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	var data = json.data
	GameData.flags = data.get("flags", {})
	GameData.values = data.get("values", {})

func load_settings() -> void:
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if !file:
		return
	var json = JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	for key in json.data:
		GameData.set_value(key, json.data[key])

func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
	
func delete_save() -> void:
	DirAccess.remove_absolute(SAVE_PATH)
