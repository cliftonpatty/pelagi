@tool
extends HBoxContainer

#ONREADYs-----------------------------------------------------------------------
@onready var textureRect : TextureRect = $PanelContainer/TextureRect
@onready var nameLabel : RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/Name
@onready var totalCaughtLabel : RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/TotalCaught
@onready var currentCaughtPill : Label = $PanelContainer/SessionCaughtContainer/PanelContainer/SessionCaught
@onready var newCatchBadge : MarginContainer = $PanelContainer/NewLabelContainer

#EXPORTs-----------------------------------------------------------------------
@export var newCatch : bool = false : 
	set(value):
		newCatch = value
		toggle_new()

@export @onready var myImage : CompressedTexture2D : 
	set(value):
		myImage = value
		new_image()
	get: return myImage

@export @onready var myName : String :
	set(value):
		myName = value
		new_name()
	get: return myName

@export @onready var totalCaught : int :
	set(value):
		totalCaught = value
		new_total()
	get: return totalCaught

@export @onready var currentCaught : int :
	set(value):
		currentCaught = value
		new_current()
	get: return currentCaught


#Initialize tool - so it updates in editor mode
func _init() -> void:
	new_image()


func _ready() -> void:
	new_image()
	toggle_new()

func toggle_new():
	if newCatchBadge:
		newCatchBadge.visible = newCatch


func new_image() -> void:
	if myImage and textureRect:
		textureRect.texture = myImage


func new_name() -> void:
	if nameLabel:
		nameLabel.text = myName.to_upper()


func new_total() -> void:
	if totalCaughtLabel:
		var formatTotal = format_score(str(totalCaught))
		totalCaughtLabel.text = formatTotal


func new_current() -> void:
	if currentCaughtPill:
		var formatTotal = format_score(str(currentCaught))
		currentCaughtPill.text = str("x", formatTotal)


func format_score(score : String) -> String:
	var i : int = score.length() - 3
	while i > 0:
		score = score.insert(i, ",")
		i = i - 3
	return score
