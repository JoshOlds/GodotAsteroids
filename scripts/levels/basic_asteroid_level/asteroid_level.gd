class_name AsteroidLevel
extends Node
## The top-level manager for an Asteroid game level. Sets up all other managers and provides information about world size

## The size of the world, in pixels
@export var world_size = Vector2(2500, 2500)

## The main camera for this Asteroid Level. Sets up this cameras limits based on world size
@export var main_camera : Camera2D

## Asteroid Spawn Manager for this level
@export var asteroid_spawn_manager : AsteroidSpawnManager

## Asteroid Cleaner for this level.
@export var asteroid_cleaner_ref : AsteroidCleaner

@export var world_barrier_generator : WorldBarrierGenerator


func _ready():
	# Setup main camera limits (so won't scroll off screen)
	main_camera.limit_left = 0
	main_camera.limit_right = world_size.x
	main_camera.limit_top = 0
	main_camera.limit_bottom = world_size.y
	
	# Setup AsteroidSpawnManager
	asteroid_spawn_manager.world_size = world_size
	asteroid_spawn_manager._setup()

	# Setup AsteroidCleaner
	asteroid_cleaner_ref.world_size = world_size
	
	world_barrier_generator.world_size = world_size
	world_barrier_generator.barrier_damage = 10
	world_barrier_generator.barrier_width = 5
	world_barrier_generator.generate_static_barriers()
	
