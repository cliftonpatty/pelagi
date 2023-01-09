extends BaseDrillable

class_name BaseFish

#Export Variables---------------------------------------------------------------
##Is this a fish that only spawns once?
@export var solo: bool = false

var fDB : Dictionary #Fishing Database - populates below
##How fast the fish can swim 
var swimSpeed: int
##How much is the fish worth if drilled?
var value: int
##Depth tier, a parent of rarity, controlling at what depth we see this fish, starts at 1, has no set end
var depthTier : int
##Rarity of the fish, lower number = more rare (rarer?)
var rarity : float

#Other Variables----------------------------------------------------------------
@onready var caught : bool = false ## A safety variable for state swapping 
@onready var catchable : bool = true ## Generally true - here for special cases like armored fish
@onready var bloodSplat: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:

	super()
	
	if myID:
		fDB = FishingDB.fishDB[myID]
		swimSpeed = fDB.swimSpeed
		value = fDB.value
		depthTier = fDB.depthTier
		rarity = fDB.rarity

	self.body_entered.connect(our_body_entered)
	self.area_entered.connect(our_area_entered)

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
