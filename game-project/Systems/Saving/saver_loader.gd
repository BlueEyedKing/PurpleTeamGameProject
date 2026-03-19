extends Node
class_name SaverLoader


func save_game():
	var file = FileAccess.open("res://savegame.json", FileAccess.WRITE)
	var data = {
		"flags": GameData.flags,
		"values": GameData.values
	}
	file.store_string(JSON.stringify(data))

func load_game():
	var file = FileAccess.open("res://savegame.json", FileAccess.READ)
	if !file:
		return
	var json = JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	var data = json.data
	GameData.flags = data.get("flags", {})
	GameData.values = data.get("values", {})
	return ["main_city", "camp_1"]
