extends Node

var dropSpeed = 300
var depth = 2000

var ascending: bool = false

func trigger_ascent():
	dropSpeed = dropSpeed * -1
	ascending = !ascending
