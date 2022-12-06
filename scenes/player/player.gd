extends CharacterBody2D

#Body and Collision-------------------------------------------------------------


const SPEED = 600.0

func _physics_process(delta: float) -> void:
	position.y += Globals.dropSpeed
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	apply_sprite_rotation(delta)
	
	move_and_slide()

func apply_sprite_rotation(delta):
	if velocity.x > 0:
		rotation = lerp_sprite(-0.5, delta)
	elif velocity.x < 0:
		rotation = lerp_sprite(0.5, delta)
	elif velocity.x > 0:
		rotation = lerp_sprite(0.5, delta)
	elif velocity.x < 0:
		rotation = lerp_sprite(-0.5, delta)
	else:
		rotation = lerp_sprite(0, delta)
		
#Smooth rotation on movement 
func lerp_sprite( target, delta ):
	return lerp_angle( rotation, target, ( 10 * delta) )
	
