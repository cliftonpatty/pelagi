extends Area2D

class_name WallHuggerBase

func set_orientation(dir):
	rotation = deg_to_rad(90 * dir)

#Sent externally -- from the player scene
func drilled_by_player():
	$Sprite2D.visible = false
	$CPUParticles2D.emitting = true
	await get_tree().create_timer(3).timeout
	queue_free()
