extends Area2D

var myID : String

func offset_catch(catch):
	catch.position = Vector2.ZERO
	catch.rotation = deg_to_rad(180)
