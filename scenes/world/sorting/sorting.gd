extends Node2D

@onready var gridRef : Node2D = $GridParent

var lastPickup 


func _ready() -> void:
	for tetro in $Tetro.get_children():
		tetro.emit_position.connect(tetro_pos_handoff)
		tetro.discard_position.connect(tetro_pos_removal)


func _process(delta: float) -> void:
	pass


func tetro_pos_handoff(pos, obj):
	gridRef.recieve_tetro_pos(pos, obj)


func tetro_pos_removal(pos, obj):
	gridRef.remove_tetro_pos(pos, obj)
	
