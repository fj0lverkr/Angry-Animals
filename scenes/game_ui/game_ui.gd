extends Control

@onready var bgm: AudioStreamPlayer = $"BGM"
@onready var level_label: Label = $"MarginContainer/VBTopLeft/LevelLabel"
@onready var attempts_label: Label = $"MarginContainer/VBTopLeft/AttemptsLabel"
@onready var vb_center: VBoxContainer = $"MarginContainer/VBCenter"

var level_completed: bool
var attempts: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vb_center.hide()
	mouse_filter = Control.MOUSE_FILTER_PASS
	bgm.seek(SceneManager.bgm_position)
	level_completed = false
	level_label.text = "Level %s" % SceneManager.get_selected_level()
	attempts_label.text = "Attempts: %s" % attempts
	SignalBus.on_level_completed.connect(_on_level_completed)
	SignalBus.on_score_updated.connect(_on_score_updated)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu") and level_completed:
		SceneManager.bgm_position = bgm.get_playback_position()
		get_tree().change_scene_to_packed(SceneManager.MAIN)

func _on_score_updated(score: int) -> void:
	attempts_label.text = "Attempts: %s" % score

func _on_level_completed() -> void:
	vb_center.show()
	mouse_filter = Control.MOUSE_FILTER_STOP
	level_completed = true
