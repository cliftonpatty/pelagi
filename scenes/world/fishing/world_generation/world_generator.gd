extends Node2D

var depth: int
var wallSegment = preload("res://scenes/world/fishing/world_generation/cave_walls.tscn")
@export var wallSize: Vector2 = Vector2( 2, 50 )
@onready @export var parentTexture: CompressedTexture2D

#Probably temporary tools to visualize the walls spawn position in the editor
@onready var leftMargin = $LeftMargin
@onready var rightMargin = $RightMargin

func _ready() -> void:
	wallSize *= 1000
	depth = Globals.depth
	var curDepth = 0
	while curDepth < depth:
		make_a_wall(curDepth, leftMargin)
		make_a_wall(curDepth, rightMargin)
		curDepth += wallSize.y

func make_a_wall(curDepth, margin) -> void:
	var newWall = wallSegment.instantiate()
	self.add_child(newWall)

	#Pass values down to new wall before running init function 
	newWall.wallHeight = wallSize.y
	newWall.wallWidth = wallSize.x
	newWall.childTexture = parentTexture
	
	# Function internal to the 'cave_walls' scene, just initializes 
	#everything once variables are set 
	
	newWall.set_extents()
	
	newWall.global_position.y = curDepth
	
	if margin == rightMargin:
		newWall.global_position.x = margin.global_position.x + wallSize.x/2
	else:
		newWall.global_position.x = margin.global_position.x - wallSize.x/2
