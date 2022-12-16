extends Node2D

var gridDimensions : Vector2 = SortingGlobals.gridDimensions
var gridSize : int = SortingGlobals.gridSize

@onready var iceBox = preload("res://assets/images/world/icebox/temp_icebox_gridblock.png")
@onready var childScript : Script = preload("res://scenes/world/sorting/grid_child.gd")

var myGrid : Array[Dictionary]
var gridStart : Vector2 #Assigned on ready, get the top left grid location (not necessarily (0,0))
var gridExtent : Vector2 #Assigned on ready, get the bottom right grid location (not necessarily (gridDimensions.x,gridDimensions.y))
var tetroPositions : Array[Vector2]


func _ready() -> void:
	var xPos = 0
	for x in gridDimensions.x:
		for y in gridDimensions.y:
			var block = new_grid_block()
			var newText = $RichTextLabel.duplicate()
			
			
			add_child(newText)
			
			block.position = Vector2(xPos,y*gridSize)
			var blockTruePos = to_global(block.global_position)
			var blockTrueGrid = Vector2( blockTruePos.x/gridSize, blockTruePos.y/gridSize )
			newText.position = block.position
			newText.text = str( 
				'(', blockTruePos.x/gridSize, ',', blockTruePos.y/gridSize, ')/n'
				)
			
			#ADD TO THE GRID ARRAY
			myGrid.append(
				{
					"location" = Vector2( blockTrueGrid.x, blockTrueGrid.y ),
					"object" = block,
					"covered" = false
				}
			)
			
		xPos+=gridSize
		
	gridStart = myGrid[0].location
	gridExtent = myGrid[len(myGrid)-1].location


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


func _process(delta: float) -> void:
	pass


func recieve_tetro_pos(pos, obj) -> void:
	
	for vect in pos:
		#Check if vector is valid, if not remove it from the array
		var valid = check_valid_stack(vect, obj)
		if valid:
			tetroPositions.append(vect)
		else:
			pos.erase(vect)
	
	#Check if our array length lines up with expected coverage, then let the object know
	if len(pos) != obj.gridCoverage:
		obj.validate_stack(false)
	else:
		obj.validate_stack(true)
	refresh_covered_grid()
	

func remove_tetro_pos(pos, obj) -> void:
	for vectToRemove in pos:
		var isCovered = search_for_vect(vectToRemove)
		if !isCovered:
			if vectToRemove in tetroPositions:
				tetroPositions.erase(vectToRemove)
		else:
			print('Vector is covered, remaining in array')
	refresh_covered_grid()

func search_for_vect(vect):
	for dictionary in myGrid:
		# Check if the search value is in the dictionary
		if vect in dictionary.values():
			if dictionary.covered:
				return true
				break
		
func refresh_covered_grid() -> void :
	for grid in myGrid:
		if grid.location in tetroPositions:
			grid.covered = true
			grid.object.modulate = '#d74500'
		else:
			grid.covered = false
			grid.object.modulate = '#fff'

func check_valid_stack(vect, obj):
	if vect.x > gridExtent.x or vect.y > gridExtent.y:
		print('invalid : out of bounds')
		return false
	elif vect.x < gridStart.x or vect.y < gridStart.y:
		print('invalid : out of bounds')
		return false
	elif vect in tetroPositions:
		print('invalid : covered')
		return false
	else:
		return true
