extends Node2D

#Onreadys ----------------------------------------------------------------------
@onready var rayLeft: RayCast2D = $RayPointingLeft
@onready var rayRight: RayCast2D = $RayPointingRight
@onready var spawnBounds: CollisionShape2D = $Area2D/CollisionShape2D

#Exported Variables-------------------------------------------------------------
##Spawnable fish as an array, only 'basic' fish here
##with rare ones spawned elsewhere (.tscn files only)
var spawnableFish: Array[Dictionary]
##Spawnable gems as an array, only 'basic' gems here
##with rare ones spawned elsewhere (.tscn files only)
@export var spawnableGems: Array[PackedScene]
##Spawn timing range (float, updates timer component)
@export var spawnTimingRange: Vector2 = Vector2(0.1,0.9)

#Spawn Variables----------------------------------------------------------------
var random_num = RandomNumberGenerator.new()
var depth: int #Updated from the parent node of the current fishing 'world'
var dTier: int = 1 #Local depth tier reference 
var fishTotalRarity: float = 0.0
#Our fish (from spawnable fish) as a sorted array of objects (dictionaries), 
#which is done in ready
var fishPile = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.depth_tier_updated.connect(generate_fish_pile)

	for fish in FishingDB.fishDB:
		#Preload the data into an array, but keep the reference in a new dictionary for readability
		var fishFromDic = load(FishingDB.fishDB[fish].ref)
		var dataPair : Dictionary = {
			"scene" = fishFromDic,
			"depth" = FishingDB.fishDB[fish].depthTier,
			"rarity" = FishingDB.fishDB[fish].rarity
		}
		spawnableFish.append(
			dataPair
			)

	if len(spawnableFish):
		generate_fish_pile(dTier)
	
#Fish Pile generation 
#This is the pool of fish that will be spawned 

func generate_fish_pile(depthTier):
	dTier = depthTier
	#This runs at start, and also whenever a new 'depth teir' is reached
	#At the time of writing this depth teir is every 100 'meters' - in world parent (Ocean)
	
	#CHECK FOR DUPES--
	for fish in spawnableFish:
		var fishFound = false
		for checkedFish in fishPile:
			if checkedFish.scene == fish.scene:
				fishFound = true
		if !fishFound:
			if fish.depth <= dTier:
				fishPile.append(fish)
				fishTotalRarity += fish.rarity 


func _on_timer_timeout() -> void:
	if Globals.ascending == false:
		if len(spawnableGems):
			#Spawn a number from -100 to 10, if it's positive, spawn a gem
			var spawnGem = random_num.randi_range(-100,10)
			if spawnGem > 0:
				#A 'random' way to decide which side we spawn it, reusing the spawnGem
				if spawnGem > 5:
					spawn_a_gem(rayLeft)
				else:
					spawn_a_gem(rayRight)

		if len(fishPile):
			spawn_a_fish()
		
		$Timer.wait_time = random_num.randf_range(spawnTimingRange.x,spawnTimingRange.y)
	else:
		$Timer.stop()

func spawn_a_gem(ray):
	if len(spawnableGems):
		var gemDex = random_num.randi_range( 0, spawnableGems.size()-1 )
		var nGem = spawnableGems[gemDex].instantiate()
		get_parent().add_child(nGem)
		
		#A dog-brained way to manage gem spawn orientation 
		if ray == rayRight:
			nGem.set_orientation(-1)
		else:
			nGem.set_orientation(1)
			
		nGem.global_position = ray.get_collision_point()


func spawn_a_fish():
	if len(fishPile):
		var newFish : Area2D = get_random_fish().instantiate()
		#Give the X-axis spawn some variance
		var xVar = random_num.randi_range( 50, spawnBounds.shape.get_rect().size.x )
		self.get_parent().add_child(newFish)
		newFish.global_position = Vector2(xVar, global_position.y)


func get_random_fish():
	if len(fishPile):
		var curTotal = 0
		var roll = randf_range(0,fishTotalRarity)
		for fish in fishPile:
			if roll < fish.rarity:
				return fish.scene
			roll -= fish.rarity

