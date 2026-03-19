extends Node

var sfx_player: AudioStreamPlayer

@export var music_player: AudioStreamPlayer
@export var ambiance_player: AudioStreamPlayer

const SFX_POOL_SIZE = 8
var sfx_pool: Array[AudioStreamPlayer] = []

const MUSIC_FADE_DURATION: float = 1.0
const MUSIC_MIN_DB: float = -40.0
const MUSIC_MAX_DB: float = 0.0

var music_tween: Tween

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

func play_music(stream: AudioStream, fade_in: bool = true) -> void:
	if music_player.stream == stream:
		return
	if music_player.playing:
		await stop_music()
	music_player.stream = stream
	music_player.stream.loop = true
	music_player.play()
	if fade_in:
		music_player.volume_db = MUSIC_MIN_DB
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", MUSIC_MAX_DB, MUSIC_FADE_DURATION)

func stop_music(fade_duration: float = MUSIC_FADE_DURATION) -> void:
	if not music_player.playing:
		return
	if music_tween:
		music_tween.kill()
	music_tween = create_tween()
	music_tween.tween_property(music_player, "volume_db", MUSIC_MIN_DB, fade_duration)
	await music_tween.finished
	music_player.stop()
	music_player.volume_db = MUSIC_MAX_DB
	
func play_ambiance(stream: AudioStream) -> void:
	ambiance_player.stream = stream
	ambiance_player.play()

func stop_ambiance() -> void:
	ambiance_player.stop()

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
