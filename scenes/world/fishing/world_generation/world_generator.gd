extends Node2D

var depth: int
var wall_segment = preload("res://scenes/world/fishing/world_generation/cave_walls.tscn")
@export var wall_size: Vector2 = Vector2( 2, 50 )
@onready @export var parentTexture: CompressedTexture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wall_size *= 1000
	depth = Globals.depth
	var curDepth = 0
	while curDepth < depth:
		make_a_wall(curDepth, 0)
		make_a_wall(curDepth, 4000)
		curDepth += wall_size.y

func make_a_wall(curDepth, offset) -> void:
	var newWall = wall_segment.instantiate()
	self.add_child(newWall)

	#Pass values down to new wall before running init function 
	newWall.wall_height = wall_size.y
	newWall.wall_width = wall_size.x
	newWall.childTexture = parentTexture
	
	# Function internal to the 'cave_walls' scene, just initializes 
	#everything once variables are set 
	
	newWall.set_extents()
	
	newWall.global_position.y = curDepth
	newWall.global_position.x = offset
	
