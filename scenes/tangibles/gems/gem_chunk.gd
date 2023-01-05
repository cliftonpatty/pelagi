extends Area2D

@onready var caught : bool = false

@export var myID: String

#Tween reference, so we can kill it if needed
var myTween: Tween


func get_caught() -> bool :
	
	#Kill our tween if it exists, this just makes sure Global Position 
	#doesn't get fucked up by two competeting interests 
	if myTween:
		myTween.kill()
	
	#Disable all collision detection and per-tick processing 
	monitorable = false
	monitoring = false
	$CollisionShape2D.disabled = true
	set_physics_process(false)
	
	#Tell our catcher that the catch was successful 
	return true
