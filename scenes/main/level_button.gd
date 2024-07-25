extends TextureButton

@export var level_option: int = 1

@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel

var selected_level: PackedScene

func _ready() -> void:
	level_label.text = str(level_option)
	selected_level = load("res://scenes/level/level%s.tscn" % level_option)

func _on_mouse_entered() -> void:
	scale = Vector2(1.05, 1.05)

func _on_mouse_exited() -> void:
	scale = Vector2(1, 1)

func _on_pressed() -> void:
	get_tree().change_scene_to_packed(selected_level)
