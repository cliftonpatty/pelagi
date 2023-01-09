extends Node2D

class_name BaseDrillable

@export var myID : String

#For transfer on catch
@onready var anchoredSprite = $Anchor
@onready var mySprite = $Anchor/PrimarySprite
@onready var myCol = $CollisionShape

func _ready() -> void:
	if myID == null:
		push_error(self.name, " has no ID and cannot access stats")

func drilled_by_player():
	pass
