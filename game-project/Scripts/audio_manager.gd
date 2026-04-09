extends Node

var sfx_player: AudioStreamPlayer

var music_player: AudioStreamPlayer
var ambiance_player: AudioStreamPlayer

const SFX_POOL_SIZE = 8
var sfx_pool: Array[AudioStreamPlayer] = []

const FADE_DURATION: float = 1.0
const MIN_DB: float = -40.0
const MAX_DB: float = 0.0

var music_tween: Tween
var ambiance_tween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	ambiance_player = AudioStreamPlayer.new()
	ambiance_player.bus = "Ambiance"
	add_child(ambiance_player)
	
	for i in SFX_POOL_SIZE:
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		sfx_pool.append(player)
	
func apply_saved_volumes() -> void:
	for bus in ["Master", "Music", "SFX", "Ambiance"]:
		var saved = GameData.settings.get("volume_" + bus.to_lower(), 0.5)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(saved))
		AudioServer.set_bus_mute(
			AudioServer.get_bus_index("Master"),
			GameData.settings.get("mute_master", false)
			)

func play_music(stream: AudioStream, fade_in: bool = true) -> void:
	if music_player.stream == stream:
		return
	if music_player.playing:
		await stop_music()
	music_player.stream = stream
	music_player.stream.loop = true
	music_player.play()
	if fade_in:
		music_player.volume_db = MIN_DB
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", MAX_DB, FADE_DURATION)

func stop_music(fade_duration: float = FADE_DURATION) -> void:
	if not music_player.playing:
		return
	if music_tween:
		music_tween.kill()
	music_tween = create_tween()
	music_tween.tween_property(music_player, "volume_db", MIN_DB, fade_duration)
	await music_tween.finished
	music_player.stop()
	music_player.volume_db = MAX_DB
	
func play_ambiance(stream: AudioStream) -> void:
	if ambiance_player.stream == stream:
		return
	if ambiance_player.playing:
		await stop_ambiance()
	ambiance_player.stream = stream
	ambiance_player.stream.loop = true
	ambiance_player.volume_db = MIN_DB
	ambiance_player.play()
	ambiance_tween = create_tween()
	ambiance_tween.tween_property(ambiance_player, "volume_db", MAX_DB, FADE_DURATION)

func stop_ambiance() -> void:
	if not ambiance_player.playing:
		return
	if ambiance_tween:
		ambiance_tween.kill()
	ambiance_tween = create_tween()
	ambiance_tween.tween_property(ambiance_player, "volume_db", MIN_DB, FADE_DURATION)
	await ambiance_tween.finished
	ambiance_player.stop()
	ambiance_player.volume_db = MAX_DB

func play_sfx(stream: AudioStream) -> void:
	var player = _get_free_sfx_player()
	if player == null:
		return
	player.stream = stream
	player.play()

func _get_free_sfx_player() -> AudioStreamPlayer:
	for player in sfx_pool:
		if not player.playing:
			return player
	return null 
