extends Node2D

@onready var player := $PlayerPackage/Player
@onready var camera: Camera2D = $Camera2D
@onready var UI := $Camera2D/Control/RichTextLabel
@onready var fishGenerator = $FishGenerator
@onready var claw = $Claw

func _physics_process(delta: float) -> void:
	
	fishGenerator.position.y += Globals.dropSpeed * delta
	if Globals.underwater:
		UI.text = str( int( (player.global_position.distance_to($DepthAndSurface.global_position ) / 100 )) )
		camera.global_position = lerp( camera.global_position, player.global_position, 20 * delta )
	else:
		UI.text = 'Above Water'
		camera.global_position = lerp( camera.global_position, claw.global_position, 20 * delta )
		player.global_position.x = lerp( player.global_position.x, claw.global_position.x, 20 * delta )
		
func _on_depth_and_surface_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		if Globals.underwater:
			Globals.underwater = false
		else:
			Globals.underwater = true
	
