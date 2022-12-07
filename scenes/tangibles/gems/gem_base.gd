extends Area2D


func set_orientation(dir):
	rotation = deg_to_rad(90 * dir)

#Sent externally -- from the player scene
func drilled_by_player():
	print('hey')
	$Sprite2D.visible = false
	$CPUParticles2D.emitting = true
	#bloodSplat.visible = true
	#bloodSplat.play("default")
	#bodySprite.visible = false
	#await bloodSplat.animation_finished
	await get_tree().create_timer(3).timeout
	queue_free()
