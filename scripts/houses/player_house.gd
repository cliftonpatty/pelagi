extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var fishLine: Node2D = $FishLine

func _ready() -> void:
	player.caught_a_fish.connect(fish_transfer)
	fishLine.playerRef = player
	
func fish_transfer(fish):
	#Wipe fish parentage so we can repatriate
	if fish.get_parent() != null:
		#print('we gone kill her mom :( ', fish.get_parent())
		var fishParent = fish.get_parent()
		fishParent.remove_child(fish)
		#print('mom ded :( ', fish.get_parent())
		fishLine.new_fish_onboarding(fish)
	else:
		print('she got a mom!')
