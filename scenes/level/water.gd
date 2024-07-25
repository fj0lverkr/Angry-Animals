extends Area2D

@onready var splash_player: AudioStreamPlayer2D = $"Splash"

func _on_body_entered(_body: Node2D) -> void:
	splash_player.play()