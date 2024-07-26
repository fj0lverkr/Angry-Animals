extends Node

const PARROT: PackedScene = preload ("res://scenes/parrot/parrot.tscn")
const MAIN: PackedScene = preload ("res://scenes/main/main.tscn")

var _selected_level: int = 1

func get_selected_level() -> int:
	return _selected_level

func set_selected_level(level_id: int) -> void:
	_selected_level = level_id

var bgm_position: float = 0.0
