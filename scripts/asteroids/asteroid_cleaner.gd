class_name AsteroidCleaner
extends Node
## Tracks all asteroids currently in the game, and handles cleaning up any asteroids that move off-screen

## Time (in seconds) between deleting off-world asteroids
@export var off_world_delete_interval : float = 1.0

# Size of the game world. Must be set by parent
var world_size : Vector2

## Array that holds all active asteroids. 
var asteroids : Array[ProcAsteroid] 
		
## Timer for clearing offscreen bullets
var _cleanup_timer : Timer	
		
		
func _ready():
	# set up cleanup timer
	_cleanup_timer = Timer.new()
	add_child(_cleanup_timer)
	_cleanup_timer.wait_time = off_world_delete_interval
	_cleanup_timer.timeout.connect(delete_off_world_asteroids)
	_cleanup_timer.start()


func add_asteroid(asteroid : ProcAsteroid):
	asteroids.append(asteroid)


func remove_asteroid(asteroid : ProcAsteroid):
	asteroids.erase(asteroid)
	

## Frees any asteroids that are fully outside of the world bounds. Returns array of asteroids to keep (that are still inside the world bounds)
func delete_off_world_asteroids():
	assert(world_size.x > 0 and world_size.y > 0, "AsteroidCleaner: World Size has not yet been set up. Please set when instantiating.")
	
	var asteroids_to_keep : Array[ProcAsteroid] = []
	var asteroids_to_free : Array[ProcAsteroid] = []
	for asteroid in asteroids:
		if asteroid.position.x < 0 - asteroid.max_radius * 2 \
			or asteroid.position.x > world_size.x + asteroid.max_radius * 2 \
			or asteroid.position.y < 0 - asteroid.max_radius * 2 \
			or asteroid.position.y > world_size.y + asteroid.max_radius * 2:
				asteroids_to_free.append(asteroid)
		else:
			asteroids_to_keep.append(asteroid)
	
	for to_free in asteroids_to_free:
		to_free.queue_free()
	asteroids = asteroids_to_keep
