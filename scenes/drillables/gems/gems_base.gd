extends Area2D

class_name GemBase

@export_category("Fish Stats")
##MyID for matching with global stats sheet
@export var myID: String

@export var lootChunk : PackedScene
@export var lootAmount : int = 0

var facing

func set_orientation(dir):
	rotation = deg_to_rad(90 * dir)
	facing = dir
	
#Sent externally -- from the player scene
func drilled_by_player():
	$Sprite2D.visible = false
	$CPUParticles2D.emitting = true
	spawn_loot()
	await get_tree().create_timer(3).timeout
	queue_free()

func spawn_loot():
	var random_num = RandomNumberGenerator.new()
	for i in lootAmount:
		var newChunk = lootChunk.instantiate()
		get_parent().call_deferred("add_child", newChunk)
		newChunk.global_position = global_position
		var tweenMove = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		var tweenDur = random_num.randi_range(1,2)
		newChunk.myTween = tweenMove
		tweenMove.tween_property( 
			newChunk, 
			"global_position", 
			Vector2(
				newChunk.global_position.x + (random_num.randi_range(150,450)*facing),
				newChunk.global_position.y + (random_num.randi_range(-150,150)*facing)
				),
			tweenDur
			)
		tweenMove.tween_property( 
			newChunk, 
			"rotation", 
			deg_to_rad(random_num.randi_range(-150,150)),
			tweenDur
			)
