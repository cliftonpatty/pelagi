extends Tetro

class_name Deco

@export var decoRange : int = 1
##The direction this decorations buffs head in
##they expand one block in each direction for each 'range' 
@export_enum( "Vertical Line", "Horizontal Line", "Cross", "Diag", "Square") var decoSpreadType: int

func _ready() -> void:
	super() #Run our parent ready func (the script we extend from)
	match decoSpreadType:
		0: # Vertical
			print('vertical')
		1: # Horizontal
			print('Horizontal')
		2: # Cross
			print('cross')
		3: # Diag
			print('diag')
		4: # Square
			print('square')


func on_settle():
	pass


#Overwriting this
func buff_toggle(active : bool, obj):
	pass
