extends Area2D

class_name Tetro

#Money Stuff--------------------------------------------------------------------
@export var valueMoney : int = 100 
@export var valueOnSpecial : bool = false
var newValue : int
var buffData : Array = []#Eventually array of dictionaries, just a flat amount now

#Init Vars and References-------------------------------------------------------
@onready var sprite = $Sprite2D
@onready var gridSize : int = SortingGlobals.gridSize #Individual grid block size
@onready var locationParent : Node2D = $Locations #Parent to individual location markers 

#WHAT GRID BLOCKS ARE BELOW US--------------------------------------------------
#Think of these tetros like moving scanners, updating a 'basket' with whatever
#objects sit below them 
var blocksBelow : Array[GridBlock] = []

#Grab and Move------------------------------------------------------------------
var mouseOver : bool = false
var trueHover : bool = false #Is the mouse over and is this the top object?
var held : bool : 
	set(v):
		held = v
		update_held(v)
var _pickupPoint : Vector2
var _dropTarget : Vector2
var posArray : Array[Vector2]

#Flagged as invalid on the grid (or off the grid)-------------------------------
var flagged = false

#Scale-------------------------------------------------------------------------
#Make the sprite larger when grabbed with this, temp fix to be replaced with tweening 
var spriteScale : Vector2
var originalScale : Vector2

#Signals------------------------------------------------------------------------
#All signals here go to the scene parent and are distrubuted from there
signal emit_position(pos, obj)
signal discard_position(pos, obj)
signal emit_hovered(obj)


func _ready() -> void:
	held = false
	newValue = valueMoney
	_dropTarget = global_position
	spriteScale = sprite.scale
	originalScale = sprite.scale


func _on_mouse_entered() -> void:
	mouseOver = true
	add_to_group('hovered')


func _on_mouse_exited() -> void:
	mouseOver = false
	remove_from_group('hovered')


func _physics_process(delta: float) -> void:
	if mouseOver or held:
		true_hover_actions(is_on_top())
	else:
		true_hover_actions(false)

	if held:
		get_pos_array()

	sprite.scale = lerp(sprite.scale, spriteScale, 10 * delta)
	if held:
		_dropTarget = get_global_mouse_position() + _pickupPoint
	
	global_position = lerp( 
		global_position,
		snapped(_dropTarget, Vector2(gridSize, gridSize)),
		10 * delta
		)


func get_pos_array() -> Array[Vector2]:
	var localArray : Array[Vector2] = []
	for item in $Locations.get_children():
		var roundedPos = Vector2(
				roundi(item.global_position.x/gridSize),
				roundi(item.global_position.y/gridSize)
				)
		#DEBUG/DELETABLE 
		var textBox = item.get_child(0)
		textBox.text = str( roundedPos )
		
		localArray.append(roundedPos)
	return localArray


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("MouseLeft"):
		if mouseOver and is_on_top():
			held = true
			_pickupPoint = global_position - get_global_mouse_position()
			spriteScale *= 1.1
			emit_signal("discard_position", get_pos_array(), self)
			
	if event.is_action_released("MouseLeft"):
		if held:
			emit_signal("emit_position", get_pos_array(), self)
			dropped_extended() # Extended drop functionality if needed 
		held = false
		spriteScale = originalScale
		_dropTarget = global_position

	if event.is_action_pressed("RotateTetro"):
		if held:
			rotation = rotation + deg_to_rad(90)

#Called externally - from the grid 
func validate_stack(val : bool) -> void:
	$TempFlag.visible = !val
	flagged = !val


func dropped_extended(): # Extended drop functionality if needed 
	pass


#Multiple objects can be hovered at once - next two functions are solving this
#Ensure that we only grab the top-most tetro
func is_on_top() -> bool:
	#potentially EXPENSIVE
	for tetro in get_tree().get_nodes_in_group('hovered'):
		if tetro.get_index() > get_index():
			return false
	return true


func true_hover_actions(active : bool) -> void:
	trueHover = active
	if trueHover:
		emit_signal("emit_hovered", self)
	else:
		pass


func refresh_grid_status():
	apply_buffs()


#Run whenever held is updated---------------------------------------------------
func update_held(v) -> void:
	pass

#UPDATE OUR LIST OF BLOCKS BELOW US---------------------------------------------
func update_blocks_below(block, addIt : bool):
	if addIt:
		blocksBelow.append(block)
	else:
		blocksBelow.erase(block)
	apply_buffs()
	
func apply_buffs():
	newValue = valueMoney
	
	if blocksBelow.any(func(el): return el.buffTotal > 0 ):
		var compareValue : int = 0 #Find highest buff 
		for block in blocksBelow:
			if block.buffTotal > compareValue:
				compareValue = block.buffTotal
		newValue *= compareValue
		
	if blocksBelow.any(func(el): return el.debuffTotal > 0 ):
		var compareValue : int = 0 #Find highest debuff 
		for block in blocksBelow:
			if block.debuffTotal > compareValue:
				compareValue = block.debuffTotal
		newValue -= (compareValue * 4)

