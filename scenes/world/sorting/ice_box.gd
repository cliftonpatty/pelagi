extends Node2D

@onready var gridRef : Node2D = $GridParent
@onready var textLabel : RichTextLabel = $Control/Panel/RichTextLabel
@onready var tetroParent : Node2D = $Tetro

var lastPickup 


func _ready() -> void:
	for tetro in tetroParent.get_children():
		tetro.emit_position.connect(tetro_pos_handoff)
		tetro.discard_position.connect(tetro_pos_removal)
		tetro.emit_hovered.connect(new_hover)


func _process(delta: float) -> void:
	pass


func tetro_pos_handoff(pos, obj):
	gridRef.recieve_tetro_pos(pos, obj)


func tetro_pos_removal(pos, obj):
	gridRef.remove_tetro_pos(pos, obj)
	#Make sure pickup is always on top - then make sure that everything 
	#settles accurately once set down 
	if lastPickup:
		lastPickup.z_index = 0
	lastPickup = obj
	lastPickup.z_index = 10


func new_hover(obj : Tetro):
	textLabel.text = str( 
		"VALUE: ", obj.newValue,'\n',
		"NAME: ", obj.name
		)
