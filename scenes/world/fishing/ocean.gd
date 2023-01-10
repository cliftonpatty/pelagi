extends Node2D

#Player-------------------------------------------------------------------------
@onready var playerPackage := $PlayerPackage
@onready var player := $PlayerPackage/Player
@onready var fishLine := $PlayerPackage/FishLine

#UI-----------------------------------------------------------------------------
@onready var camera: Camera2D = $Camera2D
@onready var depthTemp := $CanvasLayer/Control/DepthTemp
@onready var ectTemp := $CanvasLayer/Control/EctTemp

#ProcGen------------------------------------------------------------------------
@onready var fishGenerator = $FishGenerator

#World--------------------------------------------------------------------------
@onready var claw = $Claw
var depth: int #Current Depth

#On what increment should we be upgrading the depth tier? 
@export var depthTierUpdateInc: int = 20

#Who should the camera chase
var cameraTarget

func _ready() -> void:
	fishLine.screen_exit.connect(last_fish_exited)
	cameraTarget = player

func _physics_process(delta: float) -> void:
	fishGenerator.position.y += Globals.dropSpeed * delta
	
	ectTemp.text = str(playerPackage.itemsOnLine)
	
	if Globals.underwater:
		
		fishGenerator.depth = depth
		var oldDepth = depth/depthTierUpdateInc + 1
		depth = int( (player.global_position.distance_to($DepthAndSurface.global_position ) / 100 )) 
		player.depth = depth
		var newDepth = depth/depthTierUpdateInc + 1
		
		if oldDepth != newDepth:
			Globals.emit_signal("depth_tier_updated", depth/depthTierUpdateInc + 1)
		
		depthTemp.text = str(depth)
		
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
		depthTemp.text = 'Above Water'

		camera.global_position = lerp( camera.global_position, cameraTarget.global_position, 20 * delta )
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
			cameraTarget = claw
		else:
			Globals.underwater = true


func last_fish_exited(pos):
	pass
