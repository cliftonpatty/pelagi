extends BaseFish

class_name BaseSwimmer

@export var verticalSwimmer: bool = false

#FROM PARENT - click arrow on left to travel there
func _ready() -> void:
	super()
	#Simple random to determine if fish is born swimming left or right 
	if !verticalSwimmer:
		var which_dir = randi_range(-10, 10)
		if which_dir > 0:
			toggle_dir()
	else:
		rotation = deg_to_rad(-90)

func _physics_process(delta: float) -> void:
	if !verticalSwimmer:
		position.x += swimSpeed * delta
	else:
		position.y -= swimSpeed * delta


#FROM PARENT - click arrow on left to travel there
func hit_a_wall():
	toggle_dir()


#FROM PARENT - click arrow on left to travel there
func surface_struck():
	toggle_dir()


func toggle_dir():
	swimSpeed *= -1
	if verticalSwimmer:
		mySprite.flip_v = !mySprite.flip_v
	else:
		mySprite.flip_h = !mySprite.flip_h

#FROM PARENT - click arrow on left to travel there
func drilled_by_player():
	kill_fish()
	
func kill_fish():
	swimSpeed = 0
	bloodSplat.visible = true
	bloodSplat.play("default")
	mySprite.visible = false
	await bloodSplat.animation_finished
	queue_free()
	
func get_caught() -> bool :
	self.monitorable = false
	self.monitoring = false
	myCol.disabled = true
	set_physics_process(false)
	return true
