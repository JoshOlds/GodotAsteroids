class_name AsteroidSpawnManager
extends Node
## AsteroidSpawnManager is in charge of spawning asteroids as the game goes on. 
##
## Controls the types of asteroids that can spawn, their potential characteristics, and spawn rate.
##

## The AsteroidGenerator this AsteroidSpawnManager will use to spawn asteroids
@export var asteroid_generator : AsteroidGenerator

## The interval, in seconds, between asteroid spawns
@export var spawn_interval_seconds : float = 2.0

## Range of values (min, max) that spawned asteroids may have for their radius
@export var radius_range : Vector2i = Vector2i(30, 200)

## Range of values (min, max) that spawned asteroids may have for their vertice count
@export var vertices_range : Vector2i = Vector2i(6, 30)

## Range of values (min, max) that spawned asteroids may have for their jaggedness
@export var jaggedness_range : Vector2 = Vector2(0.03, 0.3)

## Range of values (min, max) that spawned asteroids may have for their force applied (which equates to travel velocity)
@export var force_range : Vector2i = Vector2i(100, 150)

## ## Range of values (min, max) (radians) that spawned asteroids may have for their angular velocity
@export var angular_velocity_range : Vector2 = Vector2(-1 * PI, PI)

## The size of the world. Must be set by a parent before calling setup()
var world_size : Vector2


func _ready():
	var timer = Timer.new()
	timer.connect("timeout", self._on_timer_timeout)
	timer.wait_time = spawn_interval_seconds
	add_child(timer)
	timer.start()


## Sets up this AsteroidSpawnManager. Should call from parent in parent's _ready()
func _setup():
	assert(world_size.x > 0 and world_size.y > 0, "AsteroidSpawnManager world_size was not set. Make sure to set this when instantiating")
	# Procedurally generate asteroid spawn path
	asteroid_generator.world_size = world_size
	asteroid_generator.generate_spawn_path()

	
func _on_timer_timeout():
	var radius = randf_range(radius_range.x, radius_range.y)
	var vertices = randf_range(vertices_range.x, vertices_range.y)
	var jaggedness = randf_range(jaggedness_range.x, jaggedness_range.y)
	var force = randf_range(force_range.x, force_range.y)
	var angular_velocity = randf_range(angular_velocity_range.x, angular_velocity_range.y)
	asteroid_generator.spawn_asteroid_at_random_location_on_path(radius, vertices, jaggedness, force, angular_velocity)
