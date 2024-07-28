extends Node2D

@onready var spawn_marker: Marker2D = $"AnimalSpawn"
@onready var launch_area: Node2D = $"LaunchArea"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.on_parrot_died.connect(_on_parrot_died)
	SignalBus.on_attempt.connect(_on_attempt)
	spawn_parrot()

func spawn_parrot() -> void:
	launch_area.modulate.a = 1
	var parrot_instance: Node = SceneManager.PARROT.instantiate()
	parrot_instance.position = spawn_marker.position
	add_child(parrot_instance)

func _on_attempt() -> void:
	launch_area.modulate.a = 0.2

func _on_parrot_died() -> void:
	call_deferred("spawn_parrot")