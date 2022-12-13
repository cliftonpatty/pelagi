extends Node2D

@onready var player := $PlayerPackage/Player
@onready var camera: Camera2D = $Camera2D
@onready var UI := $Camera2D/Control/RichTextLabel
@onready var fishGenerator = $FishGenerator
@onready var claw = $Claw

@export var depthTierUpdateInc: int = 20

var depth: int



func _physics_process(delta: float) -> void:
	fishGenerator.position.y += Globals.dropSpeed * delta
	if Globals.underwater:
		
		fishGenerator.depth = depth
		var oldDepth = depth/depthTierUpdateInc + 1
		depth = int( (player.global_position.distance_to($DepthAndSurface.global_position ) / 100 )) 
		var newDepth = depth/depthTierUpdateInc + 1
		
		if oldDepth != newDepth:
			Globals.emit_signal("depth_tier_updated", depth/depthTierUpdateInc + 1)
		
		UI.text = str(depth)
		
		if Globals.ascending:
			player_camera_position( 
				get_viewport().get_visible_rect().size.y * -0.3,
				delta
				)
		else:
			player_camera_position( 
				get_viewport().get_visible_rect().size.y * 0.3,
				delta
				)
			
	else:
		fishGenerator.depth = -1
		UI.text = 'Above Water'
		
		camera.global_position = lerp( camera.global_position, claw.global_position, 20 * delta )
		player.global_position.x = lerp( player.global_position.x, claw.global_position.x, 20 * delta )


func player_camera_position(offset, delta):
	camera.global_position = lerp( 
		camera.global_position, 
		Vector2( 
			player.global_position.x, 
			player.global_position.y + offset
			), 
		5 * delta )


func _on_depth_and_surface_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		if Globals.underwater:
			Globals.underwater = false
		else:
			Globals.underwater = true
	
