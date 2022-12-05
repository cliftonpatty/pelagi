extends Node2D

var depth: int
var wall_segment = preload("res://scenes/world/fishing/world_generation/cave_walls.tscn")
@export var wall_size: Vector2 = Vector2( 200, 1000 )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	depth = Globals.depth
	var curDepth = 0
	while curDepth < depth:
		var newWall = wall_segment.instantiate()
		self.add_child(newWall)
		newWall.wall_height = wall_size.y
		newWall.wall_width = wall_size.x
		
		# Function internal to the 'cave_walls' scene, just initializes 
		#everything once variables are set 
		newWall.set_extents()
		
		newWall.global_position.y = curDepth
		newWall.global_position.x = 150
		curDepth += wall_size.y + 5
		
		print('hey')
