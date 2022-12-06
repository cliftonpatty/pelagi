extends Node2D

@onready var player := $Player
@onready var camera: Camera2D = $Camera2D

func _physics_process(delta: float) -> void:
	camera.position = player.position
