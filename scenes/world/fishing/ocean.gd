extends Node2D

@onready var player := $PlayerPackage/Player
@onready var camera: Camera2D = $Camera2D

@onready var fishGenerator = $FishGenerator

func _physics_process(delta: float) -> void:
	camera.position = player.position
	fishGenerator.position.y += Globals.dropSpeed * delta
