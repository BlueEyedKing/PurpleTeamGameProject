extends Node

## LevelManager — loads and unloads level scenes.
## Scenes: "house", "camp_1", "main_city"

const HOUSE     = preload("res://Levels/house.tscn")
const CAMP_1    = preload("res://Levels/camp_1.tscn")
const MAIN_CITY = preload("res://Levels/main_city.tscn")

@onready var world: Node2D = $"../../World"

var current_level


func load_level(level: String, gate: String = "") -> void:
	if current_level:
		current_level.queue_free()
	match level:
		"house":
			current_level = HOUSE.instantiate()
		"camp_1":
			current_level = CAMP_1.instantiate()
		"main_city":
			current_level = MAIN_CITY.instantiate()
		_:
			push_error("LevelManager: Unknown level '%s'" % level)
			return
	world.add_child(current_level)
	if AudioLib.MUSIC.has(level):
		AudioManager.play_music(AudioLib.MUSIC[level])
	if AudioLib.AMBIANCE.has(level):
		AudioManager.play_ambiance(AudioLib.AMBIANCE[level])
	load_player(gate)


func free_level() -> void:
	if current_level:
		world.remove_child(current_level)
		current_level.queue_free()
		current_level = null


func load_player(gate: String = "") -> void:
	var player = preload("res://Player/player.tscn").instantiate()
	current_level.add_child(player)
	if gate != "":
		var spawn = current_level.get_node_or_null(gate + "/SpawnPoint")
		if spawn:
			player.global_position = spawn.global_position
	else:
		var spawn = current_level.get_node_or_null("SpawnPoint")
		if spawn:
			player.global_position = spawn.global_position
	_apply_camera_limits(player)


## Sets Camera2D limits from the first TileMapLayer's used rect so the camera
## never scrolls past the map edges. Searches children recursively in case
## the tilemap is nested.
func _apply_camera_limits(player: Node) -> void:
	var camera: Camera2D = player.get_node_or_null("Camera2D")
	if not camera:
		return

	var tilemap := _find_tilemap(current_level)
	if not tilemap or not tilemap.tile_set:
		return

	var used := tilemap.get_used_rect()
	var tile_size := Vector2(tilemap.tile_set.tile_size)
	var origin := tilemap.global_position

	camera.limit_left   = int(origin.x + used.position.x * tile_size.x)
	camera.limit_top    = int(origin.y + used.position.y * tile_size.y)
	camera.limit_right  = int(origin.x + used.end.x * tile_size.x)
	camera.limit_bottom = int(origin.y + used.end.y * tile_size.y)


## Recursively finds the first TileMapLayer in a node's children.
func _find_tilemap(node: Node) -> TileMapLayer:
	for child in node.get_children():
		if child is TileMapLayer:
			return child
		var found := _find_tilemap(child)
		if found:
			return found
	return null
