extends Node2D

@onready var mySize : int = SortingGlobals.gridSize
@onready var colorIndicator : ColorRect = $ColorRect
@onready var label : Label = $ColorRect/Label
@onready var style : StyleBoxFlat = preload("res://assets/style_boxes/deco_range_helper.tres")

@export var buffColor : Color = '4da86883'
@export var debuffColor : Color = 'b4000052'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colorIndicator.size = Vector2(mySize,mySize)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_color(buff:bool) -> void:
	await ready
	if buff: 
		colorIndicator.color = buffColor
		self.add_to_group('buff')
	else:
		colorIndicator.color = debuffColor
		self.add_to_group('debuff')
