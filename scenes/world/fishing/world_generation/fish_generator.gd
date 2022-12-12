extends Node2D

@onready var rayLeft: RayCast2D = $RayPointingLeft
@onready var rayRight: RayCast2D = $RayPointingRight

##Spawnable fish as an array, only 'basic' fish here
##with rare ones spawned elsewhere
@export var spawnableFish: Array[PackedScene] = []
@export var spawnableGems: Array[PackedScene] = []
##Spawn timing range (float, updates timer component)
@export var spawnTimingRange: Vector2 = Vector2(0.1,0.9)

@onready var spawnBounds: CollisionShape2D = $Area2D/CollisionShape2D
var random_num = RandomNumberGenerator.new()

var depth: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	if Globals.ascending == false:
		#Using all this excessive randoming to bypass the seed-based psuedo-random that GoDot uses
		#Remove randomize and random_num to generate 'random' numbers that stay static past first launch
		random_num.randomize()
		
		#Spawn a number from -10 to 1, if it's positive, spawn a gem
		var spawnGem = random_num.randi_range(-100,10)
		
		if spawnGem > 0:
			#A 'random' way to decide which side we spawn it, reusing the spawnGem
			if spawnGem > 5:
				spawn_a_gem(rayLeft)
			else:
				spawn_a_gem(rayRight)
				
		spawn_a_fish()
		
	$Timer.wait_time = random_num.randf_range(spawnTimingRange.x,spawnTimingRange.y)

func spawn_a_gem(ray):
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
	var fishDex = random_num.randi_range( 0, spawnableFish.size()-1 )
	var nFish = spawnableFish[fishDex].instantiate()
	#Give the X-axis spawn some variance
	var xVar = random_num.randi_range( 50, spawnBounds.shape.get_rect().size.x )
	self.get_parent().add_child(nFish)
	nFish.global_position = Vector2(xVar, global_position.y)
	
