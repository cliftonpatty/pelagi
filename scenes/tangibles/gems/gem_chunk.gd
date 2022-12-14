extends Sprite2D

@onready var caught : bool = true

func get_caught() -> bool :
	$Area2D.monitorable = false
	$Area2D.monitoring = false
	$CollisionShape2D.disabled = true
	set_physics_process(false)
	
	return true


func _on_area_2d_area_entered(area: Area2D) -> void:
	print('entered')
