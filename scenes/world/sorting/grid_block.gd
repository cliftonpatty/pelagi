extends Area2D

class_name GridBlock

@onready var mySprite : Sprite2D = $FramedSprite
@onready var label = $Label.text

var covered = false
var hasDeco = false
var decoRange = 0
var buffs : Array = []
var debuffs : Array = []
var buffTotal : int = 0
var debuffTotal : int = 0
var myLocation : Vector2 = Vector2.ZERO

#@onready var myText : RichTextLabel


func _ready() -> void:
	mySprite.frame = randi_range(0,mySprite.hframes-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(buffTotal,'\n',debuffTotal)
	pass


func update_buffs(buff, addIt : bool):
	
	if addIt: 
		if buff.group == 'buff':
			print('its a buff')
			buffs.append(buff.parent)
		else:
			debuffs.append(buff.parent)
	else:
		if buff.group == 'buff':
			buffs.erase(buff.parent)
		else:
			debuffs.erase(buff.parent)

	buffTotal = 0
	for obj in buffs:
		buffTotal += obj.buffValue
		
	debuffTotal = 0
	for obj in debuffs:
		debuffTotal += obj.debuffValue
