extends StaticBody2D

var wall_height: int
var wall_width: int
var childTexture: CompressedTexture2D
var myPoly: Polygon2D

@onready var col: CollisionShape2D = $CollisionShape2D


func set_extents() -> void:
	print('CHILD??', childTexture)
	col.shape.extents.y = wall_height/2
	col.shape.extents.x = wall_width/2
	col.position.y = wall_height/2
	myPoly = Polygon2D.new()
	self.add_child(myPoly)
	myPoly.set_polygon(
		PackedVector2Array(
			[
			Vector2( -(wall_width/2), 0 ),
			Vector2( (wall_width/2), 0 ),
			Vector2( (wall_width/2), wall_height ),
			Vector2( -(wall_width/2), wall_height )
			]
			)
		)
	myPoly.set_texture(childTexture)
	myPoly.texture_scale = Vector2(1,1)
	myPoly.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	myPoly.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	#polygon.set_polygon(polygon.get_polygon())
	#print( polygon.get_polygon()[2] )
