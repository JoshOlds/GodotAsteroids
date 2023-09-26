extends Node

## The node in which generated asteroids will be child to
@export var parent_node: Node

## Preloaded ProcAsteroid Scene
var proc_asteroid = preload("res://Scenes/asteroids/proc_asteroid/proc_asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(10):
		spawn_asteroid_at_random_location()

## Generate a procedural asteroid
func generate_asteroid(size: int, vertice_count: int, jaggedness : float, spawn_position: Vector2):
	var asteroid = proc_asteroid.instantiate()
	asteroid.setup(size, vertice_count, 0.1)
	asteroid.position = spawn_position
	parent_node.add_child(asteroid)
	
func spawn_asteroid_at_random_location():
	var size = randf_range(30, 300)
	var vertices = randf_range(6, 30)
	var jaggedness = randf_range(0.02, 0.3)
	var spawn_x = randf_range(0, 1920)
	var spawn_y = randf_range(0, 1280)
	generate_asteroid(size, vertices, jaggedness, Vector2(spawn_x, spawn_y))

