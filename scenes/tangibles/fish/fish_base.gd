extends Area2D

#Export Variables---------------------------------------------------------------
@export_category("Fish Stats")
##How fast the fish can swim 
@export var swimSpeed: int
##Rarity of the fish, lower number = more rare (rarer?)
@onready @export_range(0,1) var rarity = 1
##Is this a fish that only spawns once?
@onready @export var solo: bool = false

#Other Variables----------------------------------------------------------------
@onready var caught : bool = false ## A safety variable for state swapping 
@onready var bodySprite: Sprite2D = $Sprite2D
@onready var bloodSplat: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	var which_dir = randi_range(-10, 10)
	if which_dir > 0:
		toggle_dir()
	self.body_entered.connect(do_shit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x += swimSpeed * delta

func do_shit(body):
	if body.is_in_group('player'):
		pass
	else:
		toggle_dir()

func toggle_dir():
	swimSpeed *= -1
	bodySprite.flip_h = !bodySprite.flip_h

#Sent externally -- from the player scene
func drilled_by_player():
	swimSpeed = 0
	bloodSplat.visible = true
	bloodSplat.play("default")
	bodySprite.visible = false
	await bloodSplat.animation_finished
	queue_free()

func state_swap():
	monitorable = false
	monitoring = false
	$CollisionShape2D.disabled = true
	set_physics_process(false)