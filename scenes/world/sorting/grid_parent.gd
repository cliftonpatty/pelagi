extends Node2D

var gridDimensions : Vector2 = SortingGlobals.gridDimensions
var gridSize : int = SortingGlobals.gridSize

@onready var iceBox = preload("res://assets/images/world/icebox/temp_icebox_gridblock.png")
@onready var gridBlock = preload("res://scenes/world/sorting/grid_block.tscn")

var myGrid : Dictionary
var gridStart : Vector2 #Assigned on ready, top left grid location (not necessarily (0,0))
var gridExtent : Vector2 #Assigned on ready, bottom right grid location (not necessarily (gridDimensions.x,gridDimensions.y))
var buffPositions : Array[GridBlock]


func _ready() -> void:
	var xPos = 0
	var index = 0 #Easily accessed index between both 
	for x in gridDimensions.x:
		for y in gridDimensions.y:
			
			var block : GridBlock = gridBlock.instantiate()
			call_deferred("add_child", block)
			
			block.position = Vector2(xPos,y*gridSize)

			#Grid location for reference - obviously very different from position
			var blockTrueGrid = Vector2( 
				to_global(block.global_position).x/gridSize, 
				to_global(block.global_position).y/gridSize 
				)
			block.myLocation = blockTrueGrid

			#ADD TO THE GRID DICT
			myGrid[blockTrueGrid] = block

			if index == 0:
				gridStart = blockTrueGrid

			index += 1

			if index == (gridDimensions.x * gridDimensions.y):
				gridExtent = blockTrueGrid

		xPos+=gridSize

#ADD or REMOVE from GRID--------------------------------------------------------

func recieve_tetro_pos(pos, obj) -> void:
	var allValid = check_valid_loop(pos, obj)
	#If all positions are valid, move forward, otherwise flag the object 
	if allValid:
		add_to_grid(pos,obj)
		#Let the tetro know it's placed properly
		obj.validate_stack(true)
	else:
		obj.validate_stack(false)


func add_to_grid( pos : Array[Vector2], obj : Tetro) -> void:
	buffPositions = []
	for loc in pos:
		if location_within_bounds(loc):
			var gridMatch = myGrid[loc]
			gridMatch.covered = true
			gridMatch.modulate = '#d74500' #Temp color change for debug/clarity
			obj.update_blocks_below(gridMatch, true)
	if obj.is_in_group('deco'):
		obj.updated_deco_coverage()
		for buffPos in obj.buffLocations:
			if location_within_bounds(buffPos):
				var gridMatch = myGrid[buffPos]
				gridMatch.update_buffs(obj.buffLocations[buffPos], true)
				buffPositions.append(gridMatch)
	refresh_grid()


func remove_tetro_pos(pos, obj) -> void:
	if !obj.flagged:
		for loc in pos:
			if location_within_bounds(loc):
				var gridMatch = myGrid[loc]
				gridMatch.covered = false
				gridMatch.modulate = '#fff'
				obj.update_blocks_below(gridMatch, false)
		if obj.is_in_group('deco'):
			for buffPos in obj.buffLocations:
				if location_within_bounds(buffPos):
					var gridMatch = myGrid[buffPos]
					gridMatch.update_buffs(obj.buffLocations[buffPos], false)
		refresh_grid()

#REFRESH our GRID to check for BUFFS--------------------------------------------
#As of now, this is just for debugging and shit...
func refresh_grid() -> void: 
	#for item in myGrid:
	#	var itemObj = myGrid[item]
	#	if itemObj.buffs.size() > 0:
	#		itemObj.modulate = '#ff87fc'
	#	if itemObj.debuffs.size() > 0:
	#		itemObj.modulate = '#ff87fc'
	#	else:
	#		itemObj.modulate = '#fff'
	pass 

#VALIDATE POSITIONS-------------------------------------------------------------

func check_valid_loop(pos,obj):
	var allValid = true
	for vect in pos:
		#Check if vector is valid
		var valid = check_valid_pos(vect, obj)
		if !valid:
			allValid = false
	return allValid


func check_valid_pos(vect, obj): 
	var relevantBlock = myGrid.find_key(vect)
	if !location_within_bounds(vect):
		return false
	elif myGrid[vect].covered:
		print('invalid : covered')
		return false
	else:
		return true


func location_within_bounds(loc) -> bool:
	if loc.x > gridExtent.x or loc.y > gridExtent.y:
		return false
	elif loc.x < gridStart.x or loc.y < gridStart.y:
		return false
	else:
		return true
