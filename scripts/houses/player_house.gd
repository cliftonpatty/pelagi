extends Node2D

#This houses the player and the fishing line - allowing the two to communicate
#with each other more easily. 'PlayerPackage' in SceneTree 

@onready var player: CharacterBody2D = $Player
@onready var fishLine: Node2D = $FishLine

const caughtObj = preload("res://scenes/drillables/caught_object.tscn")

var itemsOnLine : Dictionary = {}

func _ready() -> void:
	player.caught_a_fish.connect(fish_transfer)
	fishLine.confirm_caught.connect(confirm_caught)
	fishLine.playerRef = player
	
func fish_transfer(fish):
	#Wipe fish parentage so we can repatriate
	if fish.get_parent() != null:
		#print('we gone kill her mom :( ', fish.get_parent())
		var fishParent = fish.anchoredSprite.get_parent()
		print(fishParent)
		
		#Remove only the anchor and the sprite from the caught fish
		#We must reparent to a new instance of the 'caughtObj'
		fishParent.remove_child(fish.anchoredSprite)
		var newCaughtObject = caughtObj.instantiate()
		newCaughtObject.add_child(fish.anchoredSprite)
		newCaughtObject.offset_catch(fish.anchoredSprite)
		#We only need myID to draw data from the database
		var newCaughtDictionary = {
			"sprite" : newCaughtObject,
			"myID" : fish.myID 
		}
		
		fishLine.new_fish_onboarding(newCaughtDictionary)
		fish.queue_free()
	else:
		pass

#Confirm what has been caught, adding it to the 'registry' that will be
#sent to the icebox - we will create a dictionary that maintains count as well

func confirm_caught(item):
	if item:
		if item in itemsOnLine:
			itemsOnLine[item].quantity += 1
		else:
			itemsOnLine[item] = {
				"quantity" : 1
			}
