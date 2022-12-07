extends Node2D

#THIS IS TEMPORARY 
@onready var top: Sprite2D = $top
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print( top.get_rect() )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if Globals.ascending:
		$bottom.position.y -= ($bottom.get_rect().size.y * 2) - 100
	else:
		top.position.y += ($bottom.get_rect().size.y * 2) - 100


func _on_visible_on_screen_notifier_2d_2_screen_exited() -> void:
	if Globals.ascending:
		top.position.y -= ($bottom.get_rect().size.y * 2) - 100
	else:
		$bottom.position.y += ($bottom.get_rect().size.y * 2) - 100
