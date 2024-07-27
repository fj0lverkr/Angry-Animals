extends Node2D

@onready var spawn_marker: Marker2D = $"AnimalSpawn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.on_parrot_died.connect(_on_water_hit)
	spawn_parrot()

func spawn_parrot() -> void:
	var parrot_instance: Node = SceneManager.PARROT.instantiate()
	parrot_instance.position = spawn_marker.position
	add_child(parrot_instance)

func _on_water_hit() -> void:
	call_deferred("spawn_parrot")