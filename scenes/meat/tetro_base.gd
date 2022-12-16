extends Area2D

#Should probably be automated - let the script know how many blocks this should cover
@export var gridCoverage : int

#Onreadys-----------------------------------------------------------------------
@onready var sprite : Sprite2D = $Sprite2D
@onready var spriteMat : ShaderMaterial = $Sprite2D.material
@onready var spriteTween : Tween
@onready var gridSize : int = SortingGlobals.gridSize

#Carry and Move-----------------------------------------------------------------
var mouseOver = false
var held = false
var dropping = false
var pickupPoint : Vector2 = Vector2.ZERO
var dropTarget : Vector2
var areasBelow : Array[Area2D] #How many grid blocks am I over? 
var tetrosBelow : Array[Area2D] #Am I touching another tetro?
var originalLocation : Vector2

#Make the sprite larger when grabbed with this, temp fix to be replaced with tweening 
var spriteScale : Vector2
var originalScale : Vector2


func _ready() -> void:
	dropTarget = global_position
	originalLocation = global_position
	spriteScale = sprite.scale
	originalScale = sprite.scale
	pass


func _physics_process(delta: float) -> void:
	#print(areasBelow)
	sprite.scale = lerp(sprite.scale, spriteScale, 10 * delta)
	if held:
		dropTarget = get_global_mouse_position() + pickupPoint
	else:
		if len(tetrosBelow):
			scoot_me()
		else:
			dropping = false
	global_position = lerp(global_position, snapped(dropTarget, Vector2(gridSize, gridSize)), 10 * delta )


func _on_mouse_entered() -> void:
	mouseOver = true


func _on_mouse_exited() -> void:
	mouseOver = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MouseLeft"):
		if mouseOver:
			held = true
			pickupPoint = global_position - get_global_mouse_position()
			spriteScale *= 1.1
	
	if event.is_action_released("MouseLeft"):
		held = false
		spriteScale = originalScale
		if len(areasBelow) > gridCoverage:
			scoot_me()
		else:
			dropTarget = global_position
	
	if event.is_action_pressed("RotateTetro"):
		if held:
			print('spin')
			rotation = rotation + deg_to_rad(90)


func scoot_me():
	dropTarget = Vector2(global_position.x,global_position.y + gridSize)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('grid'):
		areasBelow.append(area)
		area.covered = true
	if area.is_in_group('tetro'):
		tetrosBelow.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group('grid'):
		areasBelow.erase(area)
		area.covered = false
	if area.is_in_group('tetro'):
		dropping = true
		tetrosBelow.erase(area)
