extends Node2D

var gridScale : Vector2
@onready var parent : Node2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gridScale = parent.gridScale
	var xPos = 0
	for x in gridScale.x:
		for y in gridScale.y:
			var block = new_grid_block()
			block.global_position = Vector2(xPos,y*64)
		xPos+=64
		
func new_grid_block():
	var newBlock : Area2D = Area2D.new()
	var blockCol: CollisionShape2D = CollisionShape2D.new()
	var blockShape : RectangleShape2D = RectangleShape2D.new()
	blockShape.size = Vector2(50,50)
	newBlock.add_child(blockCol)
	blockCol.set_shape(blockShape)
	call_deferred("add_child", newBlock)
	return newBlock

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
