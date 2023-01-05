extends Node2D

#This houses the player and the fishing line - allowing the two to communicate
#with each other more easily. 'PlayerPackage' in SceneTree 

@onready var player: CharacterBody2D = $Player
@onready var fishLine: Node2D = $FishLine

var itemsOnLine : Dictionary = {}

func _ready() -> void:
	player.caught_a_fish.connect(fish_transfer)
	fishLine.confirm_caught.connect(confirm_caught)
	fishLine.playerRef = player
	
func fish_transfer(fish):
	#Wipe fish parentage so we can repatriate
	if fish.get_parent() != null:
		print(fish)
		#print('we gone kill her mom :( ', fish.get_parent())
		var fishParent = fish.get_parent()
		fishParent.remove_child(fish)
		#print('mom ded :( ', fish.get_parent())
		fishLine.new_fish_onboarding(fish)
	else:
		print('she got a mom!')

#Confirm what has been caught, adding it to the 'registry' that will be
#sent to the icebox - we will create a dictionary that maintains count as well

func confirm_caught(item):
	if item.myID:
		print('in here')
		if item.myID in itemsOnLine:
			print('dupe found')
			itemsOnLine[item.myID].quantity += 1
		else:
			print('new one')
			itemsOnLine[item.myID] = {
				"drops" : [],
				"quantity" : 1
			}
