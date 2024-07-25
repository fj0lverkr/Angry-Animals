extends StaticBody2D

@onready var vanish_anim: AnimationPlayer = $"VanishAnimation"

func die() -> void:
	vanish_anim.play("vanish")

func _on_vanish_animation_animation_finished(_anim_name: StringName) -> void:
	SignalBus.on_cup_vanished.emit()
	queue_free()
