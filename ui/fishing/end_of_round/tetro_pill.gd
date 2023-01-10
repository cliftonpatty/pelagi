extends MarginContainer

@onready var myLabel : Label = $PillContainer/Label

@export var tetroName : String :
	set(value):
		tetroName = value
		update_text()
	get: return tetroName
@export var tetroAmount : int : 
	set(value):
		tetroAmount = value
		update_text()
	get: return tetroAmount


func _ready() -> void:
	update_text()
	#print(tetroAmount)


func update_text() -> void:
	if myLabel:
		myLabel.text = str( tetroName, " [x", tetroAmount, "]"  )
