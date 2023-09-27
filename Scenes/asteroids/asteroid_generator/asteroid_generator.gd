class_name AsteroidGenerator
extends Node

## The node in which generated asteroids will be child to
@export var parent_node: Node

## Asteroids will be spawned at a random location along the Path2D that this PathFollow2D object belongs to
@export var asteroid_spawn_location : PathFollow2D

## Reference to AsteroidManager used to track all active asteroids. Newly generated asteroids will be added to AsteroidManager's array of Asteroids
@export var asteroid_manager : AsteroidManager

## Maximum attempts to spawn an asteroid before aborting (spawns are not allowed to overlap existing asteroids)
@export var max_spawn_attempts : int = 25

var screen_x_max : int
var screen_y_max : int
var screen_center : Vector2

## Preloaded ProcAsteroid Scene
var proc_asteroid = preload("res://Scenes/asteroids/proc_asteroid/proc_asteroid.tscn")


func _ready():
	# Grab and store the viewport information 
	var viewport_rect = get_viewport().get_visible_rect()
	screen_center = viewport_rect.get_center()
	screen_x_max = screen_center.x * 2
	screen_y_max = screen_center.y * 2
	

## Generate a procedural asteroid in motion (with a force)
func generate_asteroid(radius: int, vertice_count: int, jaggedness : float, spawn_position: Vector2, force_vector : Vector2):
	# Instantiate a ProcAsteroid scene
	var asteroid = proc_asteroid.instantiate()
	asteroid.setup(radius, vertice_count, jaggedness)
	asteroid.position = spawn_position
	parent_node.add_child(asteroid)
	asteroid_manager.add_asteroid(asteroid)
	asteroid.apply_central_force(force_vector)
	
	
## Attempts to spawn an asteroid at a random position along a given path (or defaults to the Inspector set path if none provided)
func spawn_asteroid_at_random_location_on_path(radius : int, vertice_count : int, jaggedness : float, force : float, path : PathFollow2D = null) -> bool:
	# If no path provided, use the member variable path set from editor
	if path == null:
		path =  asteroid_spawn_location
	var spawn_position : Vector2 
	var force_vector : Vector2

	# Loop until a clear position is found, then generate asteroid
	var position_clear = false
	var spawn_attempts = 0
	while position_clear == false:
		if spawn_attempts > max_spawn_attempts:
			return false
			
		# Set a random progress % along the path (get random location along path)
		path.progress_ratio = randf()
		spawn_position = path.position
		
		# Solve for inward vector towards center of screen 
		var in_vector : Vector2 = spawn_position.direction_to(screen_center)
		force_vector = in_vector * force
		
		var expanded_radius = radius + (radius * jaggedness)
		
		# Move asteroid spawn away from screen center by its expanded radius, to place just off screen
		if spawn_position.x <= 0:
			spawn_position.x -= expanded_radius
		elif spawn_position.y <= 0:
			spawn_position.y -= expanded_radius
		elif spawn_position.x >= screen_x_max:
			spawn_position.x += expanded_radius
		elif spawn_position.y >= screen_y_max:
			spawn_position.y += expanded_radius
			
		# check if position is clear, continue to attempt if not
		position_clear = check_position_is_clear_of_asteroids(expanded_radius, spawn_position)
		spawn_attempts += 1
		
	# Successfully spawn the asteroid
	generate_asteroid(radius, vertice_count, jaggedness, spawn_position, force_vector)
	return true
	

## Spawns an asteroid at a random location within the screen. Used for debug only	
func spawn_asteroid_at_random_location():
	var radius = randf_range(30, 300)
	var vertices = randf_range(6, 30)
	var jaggedness = randf_range(0.02, 0.3)
	var spawn_x = randf_range(0, 1920)
	var spawn_y = randf_range(0, 1280)
	generate_asteroid(radius, vertices, jaggedness, Vector2(spawn_x, spawn_y), Vector2(0,-10000))
	
	
## Checks supplied position and radius against all existing asteroids in the AsteroidManager and returns whether the supplied position is free of overlap
func check_position_is_clear_of_asteroids(radius : int, position : Vector2) -> bool:
	var position_clear = true
	for asteroid in asteroid_manager.asteroids:
		if position.distance_to(asteroid.position) <= radius + asteroid.max_radius:
			position_clear = false
	return position_clear
	
