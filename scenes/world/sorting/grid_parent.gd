extends Node2D

var gridDimensions : Vector2 = SortingGlobals.gridDimensions
var gridSize : int = SortingGlobals.gridSize

@onready var iceBox = preload("res://assets/images/world/icebox/temp_icebox_gridblock.png")
@onready var childScript : Script = preload("res://scenes/world/sorting/grid_child.gd")

var myGrid : Array[Dictionary]
var gridStart : Vector2 #Assigned on ready, top left grid location (not necessarily (0,0))
var gridExtent : Vector2 #Assigned on ready, bottom right grid location (not necessarily (gridDimensions.x,gridDimensions.y))
var tetroPositions : Array[Vector2]
var buffPositions : Array[Dictionary]


func _ready() -> void:
	var xPos = 0
	for x in gridDimensions.x:
		for y in gridDimensions.y:
			var block = new_grid_block()
			
			var newText = $RichTextLabel.duplicate()
			block.add_child(newText)
			block.myText = newText
			block.myText.position = Vector2(-15,-15)
			
			block.position = Vector2(xPos,y*gridSize)
			var blockTruePos = to_global(block.global_position)
			var blockTrueGrid = Vector2( blockTruePos.x/gridSize, blockTruePos.y/gridSize )
			
			block.myText.text = str( 
				'(', blockTruePos.x/gridSize, ',', blockTruePos.y/gridSize, ')/n'
				)
			
			#ADD TO THE GRID ARRAY
			myGrid.append(
				{
					"location" = Vector2( blockTrueGrid.x, blockTrueGrid.y ),
					"object" = block,
					"covered" = false,
					"buffed" = 0
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

	var allValid = check_valid_loop(pos, obj)

	#If all positions are valid, move forward, otherwise flag the object 
	if allValid:
		if obj.is_in_group('deco'):
			add_buffs(obj)
		else:
			tetroPositions += pos
		obj.validate_stack(true)
	else:
		obj.validate_stack(false)

	refresh_covered_grid()


func remove_tetro_pos(pos, obj) -> void:
	if obj.is_in_group('deco'):
		remove_buffs(obj)
	elif obj.flagged == false:
		for vectToRemove in pos:
			if vectToRemove in tetroPositions:
				tetroPositions.erase(vectToRemove)
	refresh_covered_grid()


func add_buffs(obj) -> void:
	var decoRange = obj.decoRange/2
	var decoExtents : Dictionary = {
		'sourceObj' : obj,
		'min' : Vector2(
			ceil((obj.global_position.x / gridSize) - decoRange),
			ceil((obj.global_position.y / gridSize) - decoRange)
			),
		'max' : Vector2(
			floor((obj.global_position.x / gridSize) + decoRange),
			floor((obj.global_position.y / gridSize) + decoRange),
			)
		}
	buffPositions.append(decoExtents)
	refresh_buffed_grid()


func remove_buffs(obj) -> void:
	for range in buffPositions:
		if range.sourceObj == obj:
			buffPositions.erase(range)
	refresh_buffed_grid()


func refresh_buffed_grid() -> void:
	#Wipe our buff values for safety 
	for dict in myGrid:
		dict.buffed = 0
	
	for buff in buffPositions:
		for dict in myGrid:
			print(buff)
			if dict.location.x >= buff.min.x and dict.location.y >= buff.min.y:
				if dict.location.x <= buff.max.x and dict.location.y <= buff.max.y:
					dict.buffed += 1
			
			dict.object.myText.text = str(dict.buffed)


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
			#grid.object.modulate = '#d74500'
		else:
			grid.covered = false
			#grid.object.modulate = '#fff'


func check_valid_loop(pos,obj):
	var allValid = true
	for vect in pos:
		#Check if vector is valid, if not remove it from the array
		var valid = check_valid_pos(vect, obj)
		if !valid:
			allValid = false
	return allValid


func check_valid_pos(vect, obj):
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
