extends Node

const DEFAULT_SCORE: int = 1000

var _level_scores: Dictionary = {}

func _check_and_add_level(level: String) -> void:
	if !_level_scores.has(level):
		_level_scores[level] = DEFAULT_SCORE

func set_score_for_level(score: int, level: String) -> void:
	_check_and_add_level(level)
	if score < _level_scores[level]:
		_level_scores[level] = score

func get_level_score(level: String) -> int:
	_check_and_add_level(level)
	return _level_scores[level]