extends Area2D

@onready var sprite = $Sprite2D
@onready var gridSize : int = SortingGlobals.gridSize
@onready var locationParent : Node2D = $Locations #Parent to individual location markers 
var gridCoverage : int #Lets us know how many total grid blocks this will cover, if needed 

#Grab and Move
var mouseOver : bool = false
var held : bool = false
var pickupPoint : Vector2
var dropTarget : Vector2
var posArray : Array[Vector2]

#Make the sprite larger when grabbed with this, temp fix to be replaced with tweening 
var spriteScale : Vector2
var originalScale : Vector2

signal emit_position(pos, obj)
signal discard_position(pos, obj)

func _ready() -> void:
	gridCoverage = locationParent.get_child_count()
	dropTarget = global_position
	spriteScale = sprite.scale
	originalScale = sprite.scale

func validate_stack(val : bool):
	print('INVALID')
	$TempFlag.visible = !val

func _physics_process(delta: float) -> void:
	if held:
		get_pos_array()
	#print(areasBelow)
	sprite.scale = lerp(sprite.scale, spriteScale, 10 * delta)
	if held:
		dropTarget = get_global_mouse_position() + pickupPoint
	
	global_position = lerp(global_position, snapped(dropTarget, Vector2(gridSize, gridSize)), 10 * delta )

func get_pos_array() -> Array[Vector2]:
	var localArray : Array[Vector2] = []
	for item in $Locations.get_children():
		var roundedPos = Vector2(
				roundi(item.global_position.x/gridSize),
				roundi(item.global_position.y/gridSize)
				)
		var textBox = item.get_child(0)
		textBox.text = str( roundedPos )
		localArray.append(roundedPos)
	return localArray

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MouseLeft"):
		if mouseOver:
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


	if event.is_action_pressed("RotateTetro"):
		if held:
			rotation = rotation + deg_to_rad(90)

func _on_mouse_entered() -> void:
	mouseOver = true


func _on_mouse_exited() -> void:
	mouseOver = false


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
