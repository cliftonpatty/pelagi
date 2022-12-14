extends CharacterBody2D

#Body and Collision-------------------------------------------------------------
@onready var sprite: Sprite2D = $Body/ShipSprite
@onready var hookSprite: Sprite2D = $Body/Hook
@onready var body = $Body
#SHITTY TEMP DARKNESS SIMLUATION
@onready var pinhole: Sprite2D = $Pinhole
#Actions and States-------------------------------------------------------------

@onready var drillActive: bool = false

signal caught_a_fish(fish)

const SPEED: float = 600.0

var depth = 0

func _physics_process(delta: float) -> void:
	position.y += Globals.dropSpeed * delta
	
	""" 
	ALERT
	IF PLAYER IS NOT UNDERWATER - POSITION IS CONTROLLED BY 'OCEAN' SCENE
	""" 
	if depth <= 255:
		pinhole.modulate.a8 = depth
	else:
		pinhole.modulate.a8 = 255
		
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
	if drillActive and !Globals.ascending:
		if tangible.is_in_group('drillable'):
			tangible.drilled_by_player()
	if tangible.is_in_group('fish') and drillActive == false:
		if !tangible.caught:
			if Globals.ascending == false:
				Globals.trigger_ascent()
				$Bubbles.visible = false
				sprite.frame = 2
				hookSprite.visible = true
			if tangible.catchable:
				tangible.caught = true
				call_deferred("catch_a_fish", tangible)
	if tangible.is_in_group('gems') and Globals.ascending:
		if !tangible.caught:
			tangible.caught = true
			print('GEM TOUCHY')
			call_deferred("catch_a_fish", tangible)
			
func catch_a_fish(tangible):
		var tangibleCaught = tangible.get_caught()
		if tangibleCaught:
			emit_signal("caught_a_fish", tangible)

