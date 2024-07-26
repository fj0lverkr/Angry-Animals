extends Node

const DEFAULT_SCORE: int = 1000
const SCORE_FILE: String = "user://animals.json"

var _level_scores: Dictionary = {}

func _ready() -> void:
	load_from_disk()

func _check_and_add_level(level: String) -> void:
	if !_level_scores.has(level):
		_level_scores[level] = DEFAULT_SCORE

func set_score_for_level(score: int, level: String) -> void:
	_check_and_add_level(level)
	if score < _level_scores[level]:
		_level_scores[level] = score
		save_to_disk()

func get_level_score(level: String) -> int:
	_check_and_add_level(level)
	return _level_scores[level]

func save_to_disk() -> void:
	var file: FileAccess = FileAccess.open(SCORE_FILE, FileAccess.WRITE)
	var score_json: String = JSON.stringify(_level_scores)
	file.store_string(score_json)

func load_from_disk() -> void:
	var file: FileAccess = FileAccess.open(SCORE_FILE, FileAccess.READ)
	if file == null:
		save_to_disk()
	else:
		var score_json: String = file.get_as_text()
		_level_scores = JSON.parse_string(score_json)