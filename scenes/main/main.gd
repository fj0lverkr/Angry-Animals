extends Control

@onready var birds_sound: AudioStreamPlayer2D = $"Birds2D"
@onready var bgm: AudioStreamPlayer = $"BGM"

var birds_panner: AudioEffectPanner
var is_panning_left: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bgm.seek(SceneManager.bgm_position)
	var bus_name: String = birds_sound.bus
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	birds_panner = AudioServer.get_bus_effect(bus_index, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_panning_left:
		if birds_panner.pan > - 1:
			birds_panner.pan -= 0.1 * delta
		else:
			is_panning_left = false
	else:
		if birds_panner.pan < 1:
			birds_panner.pan += 0.1 * delta
		else:
			is_panning_left = true

func _on_level_button_pressed() -> void:
	SceneManager.bgm_position = bgm.get_playback_position()
