extends BaseFish

#THE BASE CLASS FOR ALL FISH - Barring Boss Fish, Rare Exceptions
#Only use this when instancing a new scene from 'fish_base.tscn'
#Comment out any parent'ed functions not in use, as they will be overwritten
#Parented functions have a turning arrow icon to the left of the line number

##func children_ready() -> void:


#func _physics_process(delta: float) -> void:

#Borrowed from the Gems - this class really splits the bill between the two
func set_orientation(dir):
	rotation = deg_to_rad(90 * dir)


func our_area_entered(area : Area2D):
	pass


#Hit the surface, only relevant for some fish (eg vertical swimmers)
func surface_struck():
	pass


#func toggle_dir():


#Has an active drill contacted this fish?
func drilled_by_player():
	kill_fish()
	
func kill_fish():
	bloodSplat.visible = true
	bloodSplat.play("default")
	mySprite.visible = false
	await bloodSplat.animation_finished
	queue_free()
	
#func get_caught() -> bool :

