extends Area2D

class_name GridBlock

@onready var mySprite : Sprite2D = $FramedSprite

var covered = false
var buffs = 0
var myLocation : Vector2 = Vector2.ZERO

#@onready var myText : RichTextLabel


func _ready() -> void:
	mySprite.frame = randi_range(0,mySprite.hframes-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(buffs)
	pass
