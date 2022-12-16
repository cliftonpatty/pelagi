extends Node2D

var gridDimensions : Vector2 = SortingGlobals.gridDimensions
var gridSize : int = SortingGlobals.gridSize

@onready var iceBox = preload("res://assets/images/world/icebox/temp_icebox_gridblock.png")
@onready var childScript : Script = preload("res://scenes/world/sorting/grid_child.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var xPos = 0
	for x in gridDimensions.x:
		for y in gridDimensions.y:
			var block = new_grid_block()
			var newText = $RichTextLabel.duplicate()
			
			newText.global_position = Vector2(xPos - 15,y*gridSize - 15)
			newText.text = str( '(', x, ',', y, ')' )
			add_child(newText)
			
			block.global_position = Vector2(xPos,y*gridSize)
		xPos+=gridSize


func new_grid_block():
	var newBlock : Area2D = Area2D.new()
	var blockSprite : Sprite2D = Sprite2D.new()
	var blockCol: CollisionShape2D = CollisionShape2D.new()
	var blockShape : RectangleShape2D = RectangleShape2D.new()
	
	blockSprite.set_texture(iceBox)
	blockSprite.hframes = 3
	blockSprite.frame = randi_range(0,2)
	blockShape.size = Vector2(gridSize * .75,gridSize * .75)
	
	newBlock.add_child(blockCol)
	newBlock.add_child(blockSprite)
	
	
	blockCol.set_shape(blockShape)
	newBlock.add_to_group('grid')
	newBlock.set_script(childScript)
	call_deferred("add_child", newBlock)
	return newBlock


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
