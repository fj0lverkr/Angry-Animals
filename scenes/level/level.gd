extends Node2D

@onready var spawn_marker: Marker2D = $"AnimalSpawn"
@onready var bgm: AudioStreamPlayer = $"BGM"
@onready var attempt_label: Label = $Control/MarginContainer/AttemptsLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bgm.seek(SceneManager.bgm_position)
	SignalBus.on_parrot_died.connect(_on_water_hit)
	SignalBus.on_score_updated.connect(_on_score_updated)
	SignalBus.on_level_completed.connect(_on_level_completed)
	spawn_parrot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		_go_to_main_scene()

func spawn_parrot() -> void:
	var parrot_instance: Node = SceneManager.PARROT.instantiate()
	parrot_instance.position = spawn_marker.position
	add_child(parrot_instance)

func _on_water_hit() -> void:
	call_deferred("spawn_parrot")

func _on_score_updated(score: int) -> void:
	attempt_label.text = str(score)

func _go_to_main_scene() -> void:
	SceneManager.bgm_position = bgm.get_playback_position()
	get_tree().change_scene_to_packed(SceneManager.MAIN)

func _on_level_completed() -> void:
	_go_to_main_scene()