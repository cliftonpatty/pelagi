# meta-name: Basic fish template
# meta-description: A template containing all functions that are passed down (or relevant) to child fish

extends _BASE_

#THE BASE CLASS FOR ALL FISH - Barring Boss Fish, Rare Exceptions
#Comment out any parent'ed functions not in use, as they will be overwritten
#Parented functions have a turning arrow icon to the left of the line number

func children_ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


#Hit a wall on the left or right - surface collision is a seperate func
func hit_a_wall():
	pass


#Hit the surface, only relevant for some fish (eg vertical swimmers)
func surface_struck():
	pass


func toggle_dir():
	pass


#Has an active drill contacted this fish?
func drilled_by_player():
	pass


func state_swap():
	pass
