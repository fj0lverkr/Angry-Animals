extends Node

var _selected_level: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_selected_level() -> int:
	return _selected_level

func set_selected_level(level_id: int) -> void:
	_selected_level = level_id
