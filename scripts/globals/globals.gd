extends Node

var dropSpeed = 500
var depth = 2000

var underwater : bool = false
var ascending: bool = false

func trigger_ascent():
	dropSpeed = dropSpeed * -1
	ascending = !ascending
