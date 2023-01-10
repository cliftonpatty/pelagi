extends Node2D

@onready var chunks : Node2D = $Chunks
@onready var lastChunkPosition : Area2D = $LastChunkPosition
var playerRef : CharacterBody2D

#Line variables - increment is how much each fish rotates per step
var baseIncr := 5
var arcStart := ((baseIncr * baseIncr)/2)*-1

#To Find the lowest point of our line (for end of round)
var newestFishChunk

signal confirm_caught(item)
signal screen_exit(pos)

func _physics_process(delta):

	if newestFishChunk:
		lastChunkPosition.global_position = newestFishChunk.global_position

	if playerRef:
		var goalPos = playerRef.global_position
		var from = rotation
		for chunk in chunks.get_children():
			var myDex = chunk.get_index()
			
			if myDex > 0:
				chunk.global_position.x = lerp( 
					chunk.global_position.x, 
					chunks.get_child(myDex-1).global_position.x, 
					5 * delta 
					)
				chunk.global_position.y = lerp( 
					chunk.global_position.y, 
					chunks.get_child(myDex-1).global_position.y, 
					5 * delta 
					) 
			else:
				chunk.global_position.x = lerp( 
					chunk.global_position.x, 
					goalPos.x, 
					5 * delta 
					)
				chunk.global_position.y = lerp( 
					chunk.global_position.y, 
					goalPos.y + 10, 
					5 * delta 
					)
				chunk.rotation = lerp_angle(
					chunk.rotation, 
					deg_to_rad(playerRef.get_real_velocity().x)/8, 
					5 * delta
					)

func new_fish_onboarding(fish):
	
	var hookGroup = find_open_group()
	
	var arcPosition = arcStart + (baseIncr * hookGroup.get_child_count())
	
	if fish.get_parent() == null:
		hookGroup.add_child(fish)
		fish.global_position = hookGroup.global_position
		fish.rotation = deg_to_rad((arcPosition * 4) + 90)
		
		emit_signal("confirm_caught",fish.myID)
	
	
func find_open_group():
	if chunks.get_child_count() > 0:
		var lastChunk = chunks.get_child(chunks.get_child_count()-1)
		if lastChunk.get_child_count() < 1:
			return lastChunk
		else:
			var newNode = makeNewNode(chunks.get_child_count())
			return newNode
	else:
		var newNode = makeNewNode(chunks.get_child_count())
		return newNode

func makeNewNode(dex):
	var newNode = Node2D.new()
	newestFishChunk = newNode
	chunks.add_child(newNode)
	newNode.name = 'FishHunk' + str(dex)
	newNode.position = playerRef.position
	return newNode


func _on_last_chunk_position_area_entered(area: Area2D) -> void:
	emit_signal("screen_exit", lastChunkPosition)
