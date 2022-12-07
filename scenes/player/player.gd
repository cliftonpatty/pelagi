extends CharacterBody2D

#Body and Collision-------------------------------------------------------------
@onready var sprite: Sprite2D = $Body/ShipSprite
@onready var hookSprite: Sprite2D = $Body/Hook
@onready var body = $Body

#Actions and States-------------------------------------------------------------

@onready var drillActive: bool = false

signal caught_a_fish(fish)

const SPEED: float = 600.0

func _physics_process(delta: float) -> void:
	position.y += Globals.dropSpeed * delta
	
	""" 
	ALERT
	IF PLAYER IS NOT UNDERWATER - POSITION IS CONTROLLED BY 'OCEAN' SCENE
	""" 
	
	if Globals.underwater:
	
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("LeftMove", "RightMove")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		apply_sprite_rotation(delta)

	move_and_slide()
	#print(drillActive)
	
func apply_sprite_rotation(delta):
	if velocity.x > 0 and !Globals.ascending:
		rotation = lerp_sprite(-0.5, delta)
	elif velocity.x < 0 and !Globals.ascending:
		rotation = lerp_sprite(0.5, delta)
	elif velocity.x > 0  and Globals.ascending:
		rotation = lerp_sprite(0.5, delta)
	elif velocity.x < 0  and Globals.ascending:
		rotation = lerp_sprite(-0.5, delta)
	else:
		rotation = lerp_sprite(0, delta)

	
	hookSprite.rotation = lerp_angle( hookSprite.rotation, -rotation, 45 * delta )
	
#Smooth rotation on movement 
func lerp_sprite( target, delta ):
	return lerp_angle( rotation, target, ( 10 * delta) )
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Drill"):
		drillActive = true
		sprite.frame = 1

	if event.is_action_released("Drill"):
		drillActive = false
		sprite.frame = 0

func _on_fish_detection_area_entered(tangible: Area2D) -> void:
	#Is it a gem?
	if tangible.is_in_group('gems'):
		if drillActive and !Globals.ascending:
			print('GEM')
			tangible.drilled_by_player()
	#Is it a fish?
	if tangible.is_in_group('fish'):
		#Is the drill on and are we heading down?
		if drillActive and !Globals.ascending:
			tangible.drilled_by_player()
		#Is the drill off? If so, we need to catch the first fish and head up
		if drillActive == false:
			if !tangible.caught:
				if Globals.ascending == false:
					Globals.trigger_ascent()
					$Bubbles.visible = false
					sprite.frame = 2
					hookSprite.visible = true
					tangible.caught = true
					call_deferred("catch_a_fish", tangible)
				else:
					tangible.caught = true
					call_deferred("catch_a_fish", tangible)

func catch_a_fish(fish):
		fish.state_swap()
		emit_signal("caught_a_fish", fish)
