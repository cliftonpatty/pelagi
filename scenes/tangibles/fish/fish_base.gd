extends Area2D

class_name SingleFishBase

#Export Variables---------------------------------------------------------------
@export_category("Fish Stats")
##How fast the fish can swim 
@export var swimSpeed: int
##How much is the fish worth if drilled?
@export var value: int
##Depth tier, a parent of rarity, controlling at what depth we see this fish, starts at 1, has no set end
@export var depthTier : int = 1
##Rarity of the fish, lower number = more rare (rarer?)
@export_range(0,1.0) var rarity : float = 1.0
##Is this a fish that only spawns once?
@export var solo: bool = false

#Other Variables----------------------------------------------------------------
@onready var caught : bool = false ## A safety variable for state swapping 
@onready var catchable : bool = true ## Generally true - here for special cases like armored fish
@onready var bodySprite: Sprite2D = $MainSprite
@onready var bloodSplat: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	self.body_entered.connect(our_body_entered)
	self.area_entered.connect(our_area_entered)
	children_ready()

#A functional for inherited scenes, so they don't overwrite parent's ready
#This will be overwritten in children scenes 
func children_ready():
	pass

func our_area_entered(area : Area2D):
	if area.is_in_group('surface'):
		surface_struck()

func surface_struck():
	pass

func our_body_entered(body):
	if body.is_in_group('player'):
		pass
	else:
		hit_a_wall()

func hit_a_wall():
	pass

#Sent externally -- from the player scene
func drilled_by_player():
	pass

func get_caught() -> bool :
	return true
