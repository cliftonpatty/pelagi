extends StaticBody2D

var wallHeight: int
var wallWidth: int
var childTexture: CompressedTexture2D
var myPoly: Polygon2D

@onready var col: CollisionShape2D = $CollisionShape2D


func set_extents() -> void:
	print('CHILD??', childTexture)
	col.shape.extents.y = wallHeight/2
	col.shape.extents.x = wallWidth/2
	col.position.y = wallHeight/2
	myPoly = Polygon2D.new()
	self.add_child(myPoly)
	myPoly.set_polygon(
		PackedVector2Array(
			[
			Vector2( -(wallWidth/2), 0 ),
			Vector2( (wallWidth/2), 0 ),
			Vector2( (wallWidth/2), wallHeight ),
			Vector2( -(wallWidth/2), wallHeight )
			]
			)
		)
	myPoly.set_texture(childTexture)
	myPoly.texture_scale = Vector2(2,2)
	myPoly.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	myPoly.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	#polygon.set_polygon(polygon.get_polygon())
	#print( polygon.get_polygon()[2] )
