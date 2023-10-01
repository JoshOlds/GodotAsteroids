class_name AsteroidGenerator
extends Node
## Class which handles generating asteroids. 
##
## Functionality is provided to spawn asteroids along a Path2D, and for generating this Path2D based on world_size.

## The node in which generated asteroids will be child to
@export var parent_node: Node

## Reference to AsteroidManager used to track all active asteroids. Newly generated asteroids will be added to AsteroidManager's array of Asteroids
@export var asteroid_manager : AsteroidManager

## Maximum attempts to spawn an asteroid before aborting (spawns are not allowed to overlap existing asteroids)
@export var max_spawn_attempts : int = 25

## The size of the world in pixels. Used to generate spawn path and for solving trajectory of asteroids
@export var world_size : Vector2

## Asteroid trajectory will be rotated by +- this value. Value in radians
## 0 causes asteroids to always move towards screen center, larger values cause asteroids to deviate from a center trajectory
@export var asteroid_trajectory_angle_randomness : float = PI / 4

## Multiplier for asteroid mass. Asteroid mass = radius * mass_multiplier
@export var asteroid_mass_multiplier : float = 5

## Asteroids will be spawned at a random location along this Path2D. Use generate_spawn_path() to procedurally create this path based on world size
@onready var asteroid_spawn_path : Path2D = get_node("Path2D")

@onready var asteroid_spawn_path_follow : PathFollow2D = get_node("Path2D/PathFollow2D")

## Flag specifying if the Path2D has been setup (generate_spawn_path() has been called)
var path_has_been_setup : bool = false

## Preloaded ProcAsteroid Scene
var proc_asteroid = preload("res://Scenes/asteroids/proc_asteroid/proc_asteroid.tscn")
	

## Procedurally generates the asteroid spawn path based on world size. Path will follow the outside edge of the world
func generate_spawn_path():
	var curve = Curve2D.new()
	curve.add_point(Vector2(0, 0))
	curve.add_point(Vector2(world_size.x, 0))
	curve.add_point(Vector2(world_size.x, world_size.y))
	curve.add_point(Vector2(0, world_size.y))
	curve.add_point(Vector2(0, 0))
	asteroid_spawn_path.curve = curve
	path_has_been_setup = true


## Generate a procedural asteroid in motion (with a force)
func generate_asteroid(radius: int, vertice_count: int, jaggedness : float, spawn_position: Vector2, force_vector : Vector2, angular_velocity : float):
	# Instantiate a ProcAsteroid scene
	var asteroid = proc_asteroid.instantiate() as ProcAsteroid
	asteroid.setup(radius, asteroid_mass_multiplier, vertice_count, jaggedness, asteroid_manager)
	asteroid.position = spawn_position
	parent_node.add_child(asteroid)
	asteroid.angular_velocity = angular_velocity
	asteroid.apply_central_impulse(force_vector)

	
## Attempts to spawn an asteroid at a random position along a given path (or defaults to the generated member path if none provided)
func spawn_asteroid_at_random_location_on_path(radius : int, vertice_count : int, jaggedness : float, force : float, angular_velocity : float, path_follow : PathFollow2D = null) -> bool:
	# If no path provided, use the member variable path 
	if path_follow == null:
		assert(path_has_been_setup, "AsteroidGenerator: Path2D has not been setup. Please call generate_spawn_path() before attempting to spawn asteroids with default path.")
		path_follow = asteroid_spawn_path_follow
	var spawn_position : Vector2 
	var force_vector : Vector2

	# Loop until a clear position is found, then generate asteroid
	var position_clear = false
	var spawn_attempts = 0
	while position_clear == false:
		# Log warning if failed to spawn
		if spawn_attempts > max_spawn_attempts:
			push_warning("Failed to find clear space to spawn asteroid")
			return false
			
		# Set a random progress % along the path (get random location along path)
		path_follow.progress_ratio = randf()
		spawn_position = path_follow.position
		
		# Solve for inward vector towards center of world 
		var world_center = Vector2(world_size.x / 2, world_size.y / 2)
		var in_vector : Vector2 = spawn_position.direction_to(world_center)
		# Apply randomness to vector
		in_vector = in_vector.rotated(randf_range(-asteroid_trajectory_angle_randomness, asteroid_trajectory_angle_randomness))

		# Scale by force value
		force_vector = in_vector * force
		
		var expanded_radius = radius + (radius * jaggedness)
		
		# Move asteroid spawn away from world center by its expanded radius, to place just off screen
		if spawn_position.x <= 0:
			spawn_position.x -= expanded_radius
		elif spawn_position.y <= 0:
			spawn_position.y -= expanded_radius
		elif spawn_position.x >= world_size.x:
			spawn_position.x += expanded_radius
		elif spawn_position.y >= world_size.y:
			spawn_position.y += expanded_radius
			
		# check if position is clear, retry spawn if not
		position_clear = check_position_is_clear_of_asteroids(expanded_radius, spawn_position)
		spawn_attempts += 1
		
	# Successfully spawn the asteroid
	generate_asteroid(radius, vertice_count, jaggedness, spawn_position, force_vector, angular_velocity)
	return true
	
	
## Checks supplied position and radius against all existing asteroids in the AsteroidManager and returns whether the supplied position is free of overlap
func check_position_is_clear_of_asteroids(radius : int, position : Vector2) -> bool:
	var position_clear = true
	for asteroid in asteroid_manager.asteroids:
		if position.distance_to(asteroid.position) <= radius + asteroid.max_radius:
			position_clear = false
	return position_clear
	
