extends StaticBody2D

var wall_height: int
var wall_width: int
var color: color
@onready var col: CollisionShape2D = $CollisionShape2D
#@onready var polygon: Polygon2D = $Polygon2D

func set_extents() -> void:
	col.shape.extents.y = wall_height/2
	col.shape.extents.x = wall_width/2
	col.position.y = wall_height/2
	var newPoly = Polygon2D.new()
	self.add_child(newPoly)
	newPoly.set_polygon(
		PackedVector2Array(
			[
			Vector2( -(wall_width/2), 0 ),
			Vector2( (wall_width/2), 0 ),
			Vector2( (wall_width/2), wall_height ),
			Vector2( -(wall_width/2), wall_height )
			]
			)
		)
	#polygon.set_polygon(polygon.get_polygon())
	#print( polygon.get_polygon()[2] )
