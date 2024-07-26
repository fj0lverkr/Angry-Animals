extends Node

var _attempts: int = 0
var _cups_hit: int = 0
var _total_cups: int = 0
var _level_id: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_total_cups = get_tree().get_nodes_in_group("cups").size()
	_level_id = SceneManager.get_selected_level()
	SignalBus.on_attempt.connect(_on_attempt)
	SignalBus.on_cup_vanished.connect(_on_cup_vanished)

func _on_attempt() -> void:
	_attempts += 1

func _on_cup_vanished() -> void:
	_cups_hit += 1
	if _cups_hit == _total_cups:
		ScoreManager.set_score_for_level(_attempts, str(_level_id))
		pass
