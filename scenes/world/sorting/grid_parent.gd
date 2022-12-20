extends Node2D

var gridDimensions : Vector2 = SortingGlobals.gridDimensions
var gridSize : int = SortingGlobals.gridSize

@onready var iceBox = preload("res://assets/images/world/icebox/temp_icebox_gridblock.png")
@onready var gridBlock = preload("res://scenes/world/sorting/grid_block.tscn")

var myGrid : Array[GridBlock]
var gridStart : Vector2 #Assigned on ready, top left grid location (not necessarily (0,0))
var gridExtent : Vector2 #Assigned on ready, bottom right grid location (not necessarily (gridDimensions.x,gridDimensions.y))
var buffPositions : Array[GridBlock]


func _ready() -> void:
	var xPos = 0
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

			#ADD TO THE GRID ARRAY
			myGrid.append( block )
			
		xPos+=gridSize
		
	gridStart = myGrid[0].myLocation
	gridExtent = myGrid[len(myGrid)-1].myLocation


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
	for grid in myGrid:
		if obj.is_in_group('deco'):
			for i in obj.decoRange:
				var inc : int = i + 1
				var loc : Vector2 = grid.myLocation
				buffPositions += myGrid.filter( func(el):return el.myLocation == Vector2(loc.x - inc, loc.y ) )
				buffPositions += myGrid.filter( func(el):return el.myLocation == Vector2(loc.x + inc, loc.y ) )
				buffPositions += myGrid.filter( func(el):return el.myLocation == Vector2(loc.x, loc.y - inc ) )
				buffPositions += myGrid.filter( func(el):return el.myLocation == Vector2(loc.x, loc.y + inc ) )
		if grid.myLocation in pos:
			grid.covered = true
			grid.modulate = '#d74500' #Temp color change for debug/clarity 

	refresh_grid()

func remove_tetro_pos(pos, obj) -> void:
	if !obj.flagged:
		for grid in myGrid:
			if grid.myLocation in pos:
				grid.covered = false
				grid.modulate = '#fff'
		refresh_grid()

func refresh_grid() -> void: 
	#Wipe our buff values for safety 
	for block in myGrid:
		block.buffs = 0

	for buffObj in buffPositions:
		buffObj.buffs += 1

#This and check_valid_pos could easily be combined 
func check_valid_loop(pos,obj):
	var allValid = true
	for vect in pos:
		#Check if vector is valid
		var valid = check_valid_pos(vect, obj)
		if !valid:
			allValid = false
	return allValid


func check_valid_pos(vect, obj): 
	var relevantBlock = myGrid.filter( func(el): return vect == el.myLocation )
	if vect.x > gridExtent.x or vect.y > gridExtent.y:
		print('invalid : out of bounds')
		return false
	elif vect.x < gridStart.x or vect.y < gridStart.y:
		print('invalid : out of bounds')
		return false
	elif len(relevantBlock) and relevantBlock[0].covered:
		print('invalid : covered')
		return false
	else:
		return true
