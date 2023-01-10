extends Node2D

func offset_catch(catch):
	catch.position = Vector2.ZERO
	catch.rotation = deg_to_rad(180)
