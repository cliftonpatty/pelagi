extends Tetro

class_name Deco

@export var decoRange : int = 1

func _ready() -> void:
	super() #Run our parent ready func (the script we extend from)

func on_settle():
	pass


#Overwriting this
func buff_toggle(active : bool, obj):
	pass
