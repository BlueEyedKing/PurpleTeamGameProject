extends Control

signal close_requested

const MIN_DB: float = -40.0
const MAX_DB: float = 0.0
@onready var master_slider: HSlider = $MarginContainer/Volume/Master
@onready var music_slider: HSlider = $MarginContainer/Volume/Music
@onready var ambiance_slider: HSlider = $MarginContainer/Volume/Ambiance
@onready var sfx_slider: HSlider = $MarginContainer/Volume/SFX
@onready var mute_button: CheckBox = $MarginContainer/Volume/Mute
@onready var close_button: Button = $MarginContainer/Volume/CloseButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	close_button.pressed.connect(func(): close_requested.emit())
	
	_init_slider(master_slider, "Master", _on_master_changed)
	_init_slider(music_slider, "Music", _on_music_changed)
	_init_slider(ambiance_slider, "Ambiance", _on_ambiance_changed)
	_init_slider(sfx_slider, "SFX", _on_sfx_changed)
		
	mute_button.button_pressed = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	mute_button.toggled.connect(_on_mute_toggled)

func _init_slider(slider: HSlider, bus: String, callback: Callable) -> void:
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.01
	var current_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))
	slider.value = db_to_linear(current_db)
	slider.value_changed.connect(callback)
	
func _set_bus_volume(bus: String, linear: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(linear))
	
func _on_master_changed(value: float) -> void:
	_set_bus_volume("Master", value)
	
func _on_music_changed(value: float) -> void:
	_set_bus_volume("Music", value)
	
func _on_ambiance_changed(value: float) -> void:
	_set_bus_volume("Ambiance", value)
	
func _on_sfx_changed(value: float) -> void:
	_set_bus_volume("SFX", value)
	
func _on_mute_toggled(toggled_on: bool) -> void:
	AudioManager.play_sfx(AudioLib.SFX["MenuClick"])
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)
	
