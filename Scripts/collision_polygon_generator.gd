extends CollisionPolygon2D

var vertices : PackedVector2Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_polygon_line_drawer_output_packed_2d_vector(vectors):
	vertices = vectors
	generate_collision_polygon()

func generate_collision_polygon():
	polygon = vertices
