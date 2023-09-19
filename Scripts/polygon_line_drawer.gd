extends Node2D

signal output_packed_2d_vector(vectors : PackedVector2Array)

var vertices : Array[Vector2]
@export var size_scalar : float = 100
@export var vertice_count : float = 10

func _draw():
	# Generate points around circle
	for i in vertices.size() - 1:
		draw_line(vertices[i], vertices[i+1], Color.WHITE, 2, true)
	draw_line(vertices[vertices.size()-1], vertices[0], Color.WHITE, 2, true)
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var angle_step = (2 * PI) / vertice_count
	for x in range(vertice_count):
		var vertex = Vector2(cos(x * angle_step) * size_scalar, sin(x * angle_step) * size_scalar)
		vertices.append(vertex)
	var output = PackedVector2Array(vertices)
	output_packed_2d_vector.emit(output)
	
	$"..".mass = size_scalar / 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
