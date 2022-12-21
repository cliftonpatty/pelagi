extends Tetro

class_name Deco

@onready var indicatorInst : PackedScene = preload("res://scenes/meat/deco_range_helper.tscn")

@onready var panelParent : Control = $PanelParent

@export var decoRange : int = 2

@export var buffValue : int = 2
##The direction this decorations buffs head in
##they expand one block in each direction for each 'range' 
@export_enum( "Vertical Line", "Horizontal Line", "Cross", "Diag", "Square") var decoBuffType: int

@export var debuffValue : int = 4
##USUALLY NONE
##The direction this decorations debuffs head in
##they expand one block in each direction for each 'range' 
@export_enum( "Vertical Line", "Horizontal Line", "Cross", "Diag", "Square", "None") var decoDebuffType: int = 5

var buffLocations : Dictionary = {}

func _ready() -> void:
	if decoDebuffType == decoBuffType:
		push_warning("You've got stacked Buffs and Debuffs - Prob Unintentional")
		
	posArray.append(Vector2.ZERO)
	super() #Run our parent ready func (the script we extend from)
	match decoBuffType:
		0: # Vertical
			up_and_down(true)
		1: # Horizontal
			left_and_right(true)
		2: # Cross
			up_and_down(true)
			left_and_right(true)
		3: # Diag
			diag(true)
		4: # Square
			square(true)
			
	match decoDebuffType:
		0: # Vertical
			up_and_down(false)
		1: # Horizontal
			left_and_right(false)
		2: # Cross
			up_and_down(false)
			left_and_right(false)
		3: # Diag
			diag(false)
		4: # Square
			square(false)
		5: # NONE
			pass

	buffLocations = get_deco_locations()

func get_deco_locations() -> Dictionary:
	var returnDict = {}
	for panel in panelParent.get_children():
		var location = Vector2(
			to_global(panel.position).x/gridSize,
			to_global(panel.position).y/gridSize
		)
		
		var myGroup 
		if panel.is_in_group('buff'):
			myGroup = 'buff'
		if panel.is_in_group('debuff'):
			myGroup = 'debuff'

		returnDict[round(location)] = {
			'parent' : self,
			'group' : myGroup
		}

	return returnDict


func up_and_down(buff : bool):
	for i in range(-decoRange, decoRange + 1):
		if i != 0:
			add_block(Vector2(0, i * gridSize), buff)

func left_and_right(buff : bool):
	for i in range(-decoRange, decoRange + 1):
		if i != 0:
			add_block(Vector2(i * gridSize, 0), buff)

func diag(buff : bool):
	for i in range(-decoRange, decoRange + 1):
		if i != 0:
			add_block(Vector2(i * gridSize,i * gridSize), buff)
			add_block(Vector2(i * gridSize,-(i * gridSize)), buff)
			
func square(buff : bool):
	#I hate this but it works and it's fast so whatever. 
	var locations : Array[Vector2] = []
	for i in range(-decoRange, decoRange + 1):
		var testLoc = Vector2(-(i * gridSize),-(decoRange * gridSize))
		if !locations.has(testLoc):
			locations.append( testLoc )
		testLoc = Vector2(-(i * gridSize), decoRange * gridSize)
		if !locations.has(testLoc):
			locations.append( testLoc )
		testLoc = Vector2(-(decoRange * gridSize),-(i * gridSize))
		if !locations.has(testLoc):
			locations.append( testLoc )
		testLoc = Vector2(decoRange * gridSize,-(i * gridSize))
		if !locations.has(testLoc):
			locations.append( testLoc )

	for x in locations:
		add_block(x, buff)

func add_block(loc : Vector2, buff : bool):
	var newIndicator = indicatorInst.instantiate()
	panelParent.call_deferred("add_child", newIndicator)
	newIndicator.position = loc
	newIndicator.toggle_color(buff)


func dropped_extended():
	updated_deco_coverage()

#Get the gridblocks underneath our decoration locations

func updated_deco_coverage():
	buffLocations.clear()
	buffLocations = get_deco_locations()


func update_held(v):
	for panel in panelParent.get_children():
		panel.colorIndicator.visible = v
