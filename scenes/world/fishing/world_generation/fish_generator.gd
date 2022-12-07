extends Node2D

##Spawnable fish as an array, only 'basic' fish here
##with rare ones spawned elsewhere
@export var spawnableFish: Array[PackedScene] = []
##Spawn timing range (float, updates timer component)
@export var spawnTimingRange: Vector2 = Vector2(0.1,0.9)

@onready var spawnBounds: CollisionShape2D = $Area2D/CollisionShape2D
var random_num = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	if Globals.ascending == false:
		#Using all this excessive randoming to bypass the seed-based psuedo-random that GoDot uses
		#Remove randomize and random_num to generate 'random' numbers that stay static past first launch
		random_num.randomize()
		
		var dex = random_num.randi_range( 0, spawnableFish.size()-1 )
		
		var nFish = spawnableFish[dex].instantiate()
		
		#Give the X-axis spawn some variance
		var xVar = random_num.randi_range( 50, spawnBounds.shape.get_rect().size.x )
		self.get_parent().add_child(nFish)
		nFish.global_position = Vector2(xVar, global_position.y)
		$Timer.wait_time = random_num.randf_range(spawnTimingRange.x,spawnTimingRange.y)
