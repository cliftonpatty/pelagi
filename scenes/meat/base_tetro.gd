extends Area2D

class_name Tetro

#Money Stuff--------------------------------------------------------------------
@export var valueMoney : int = 100 
@export var valueOnSpecial : bool = false
var newValue : int

#Init Vars and References-------------------------------------------------------
@onready var sprite = $Sprite2D
@onready var gridSize : int = SortingGlobals.gridSize #Individual grid block size
@onready var locationParent : Node2D = $Locations #Parent to individual location markers 
var gridCoverage : int #Lets us know how many total grid blocks this will cover, if needed 

#Grab and Move------------------------------------------------------------------
var mouseOver : bool = false
var trueHover : bool = false #Is the mouse over and is this the top object?
var held : bool = false
var pickupPoint : Vector2
var dropTarget : Vector2
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
	newValue = valueMoney
	gridCoverage = locationParent.get_child_count()
	dropTarget = global_position
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
		dropTarget = get_global_mouse_position() + pickupPoint
	
	global_position = lerp( 
		global_position,
		snapped(dropTarget, Vector2(gridSize, gridSize)),
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
			pickupPoint = global_position - get_global_mouse_position()
			spriteScale *= 1.1
			emit_signal("discard_position", get_pos_array(), self)
			
	if event.is_action_released("MouseLeft"):
		if held:
			emit_signal("emit_position", get_pos_array(), self)
			
		held = false
		spriteScale = originalScale
		dropTarget = global_position
		
		#Runs EVERY tetros settle function - this is to calculate 
		#buffs/debuffs/adjacencies/blah blah blah
		on_settle() 

	if event.is_action_pressed("RotateTetro"):
		if held:
			rotation = rotation + deg_to_rad(90)

#Called externally - from the grid 
func validate_stack(val : bool):
	$TempFlag.visible = !val
	flagged = !val


#What to do once we are placed and happy 
func on_settle():
	pass

#Multiple objects can be hovered at once - next two functions are solving this
#Ensure that we only grab the top-most tetro
func is_on_top() -> bool:
	#potentially EXPENSIVE
	for tetro in get_tree().get_nodes_in_group('hovered'):
		if tetro.get_index() > get_index():
			return false
	return true


func true_hover_actions(active : bool):
	trueHover = active
	if trueHover:
		emit_signal("emit_hovered", self)
	else:
		pass
