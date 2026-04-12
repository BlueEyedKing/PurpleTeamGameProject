extends Node

var flags: Dictionary = {}
var values: Dictionary = {}
var settings: Dictionary = {
	"volume_master": 0.5,
	"volume_music": 0.5,
	"volume_ambiance": 0.5,
	"volume_sfx": 0.5,
	"mute_master": false
}

func set_flag(flag: String) -> void:
	flags[flag] = true
	
func remove_flag(flag: String) -> void:
	flags.erase(flag)

func has_flag(flag: String, default = false) -> bool:
	return flags.get(flag, default)

func set_value(key: String, value):
	values[key] = value

func get_value(key: String, default = null):
	return values.get(key, default)
