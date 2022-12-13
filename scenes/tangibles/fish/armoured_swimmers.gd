extends DirectionalSwimmer

#-------------------------------------------------------------------------------
#INHERITED, Non-exported variables
#caught : bool = false ## A safety variable for state swapping 
#bodySprite: Sprite2D = $MainSprite
#bloodSplat: AnimatedSprite2D = $AnimatedSprite2D
#-------------------------------------------------------------------------------

@export_category("Armored Fish")
@export var newSprite : CompressedTexture2D = null

@export_category("Particle")
@export var chunkImage : CompressedTexture2D = null
@export var chunkImage_HFrames : int = 1
#-------------------------------------------------------------------------------

@onready var bodyShrapnel : CPUParticles2D = $CPUParticles2D

#Makes sure you can't immediatley drill the fish you just broke the armor from 
var armorBreakProtection = false

var armorActive = true

#THE BASE CLASS FOR ALL FISH - Barring Boss Fish, Rare Exceptions
#Comment out any parent'ed functions not in use, as they will be overwritten
#Parented functions have a turning arrow icon to the left of the line number

func children_ready() -> void:
	#This runs the parent func then the childs
	#I try to avoid because it is easily missed 
	super()
	if chunkImage:
		bodyShrapnel.set_texture(chunkImage)
		bodyShrapnel.material.particles_anim_h_frames = chunkImage_HFrames
	catchable = false
	

#func _physics_process(delta: float) -> void:


#Hit a wall on the left or right - surface collision is a seperate func
#func hit_a_wall():


#Hit the surface, only relevant for some fish (eg vertical swimmers)
#func surface_struck():


#func toggle_dir():


#Has an active drill contacted this fish?
func drilled_by_player():
	if !catchable:
		if !armorBreakProtection:
			armorBreakProtection = true
			bodyShrapnel.emitting = true
			bodySprite.set_texture(newSprite)
			
			#Maybe should be placed below await??? NEEDS MORE TESTING
			catchable = true
			
			await get_tree().create_timer(2).timeout
			
			armorBreakProtection = true
			bodyShrapnel.emitting = false
			
	else: 
		kill_fish()
		
func kill_fish():
	swimSpeed = 0
	bloodSplat.visible = true
	bloodSplat.play("default")
	bodySprite.visible = false
	await bloodSplat.animation_finished
	queue_free()

func get_caught() -> bool :
	if !catchable:
		return false
	else:
		monitorable = false
		monitoring = false
		$CollisionShape2D.disabled = true
		set_physics_process(false)
		return true
