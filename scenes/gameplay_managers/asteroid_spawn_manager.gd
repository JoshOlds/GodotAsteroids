class_name AsteroidSpawnManager
extends Node
## AsteroidSpawnManager is in charge of spawning asteroids as the game goes on. 
##
## Controls the types of asteroids that can spawn, their potential characteristics, and spawn rate.
##

## The AsteroidGenerator this AsteroidSpawnManager will use to spawn asteroids
@export var asteroid_generator : AsteroidGenerator

## Reference to AsteroidGameMetrics - used to calculate difficulty based on session time and score
@export var asteroid_game_metrics : AsteroidGameMetrics

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

var _asteroid_spawn_timer : Timer

var _difficulty_timer : Timer

var _difficulty_counter : int = 0


func _ready():
	_asteroid_spawn_timer = Timer.new()
	_asteroid_spawn_timer.connect("timeout", self._on_asteroid_spawn_timer)
	_asteroid_spawn_timer.wait_time = spawn_interval_seconds
	add_child(_asteroid_spawn_timer)
	_asteroid_spawn_timer.start()

	_difficulty_timer = Timer.new()
	_difficulty_timer.connect("timeout", self._on_difficulty_timer)
	_difficulty_timer.wait_time = 1.0
	add_child(_difficulty_timer)
	_difficulty_timer.start()


## Sets up this AsteroidSpawnManager. Should call from parent in parent's _ready()
func _setup():
	assert(world_size.x > 0 and world_size.y > 0, "AsteroidSpawnManager world_size was not set. Make sure to set this when instantiating")
	# Procedurally generate asteroid spawn path
	asteroid_generator.world_size = world_size
	asteroid_generator.generate_spawn_path()

	
func _on_asteroid_spawn_timer():
	var radius = randf_range(radius_range.x, radius_range.y)
	var vertices = randf_range(vertices_range.x, vertices_range.y)
	var jaggedness = randf_range(jaggedness_range.x, jaggedness_range.y)
	var force = randf_range(force_range.x, force_range.y)
	var angular_velocity = randf_range(angular_velocity_range.x, angular_velocity_range.y)
	asteroid_generator.spawn_asteroid_at_random_location_on_path(radius, vertices, jaggedness, force, angular_velocity)


func _on_difficulty_timer():
	_difficulty_counter += 1

	if _difficulty_counter >= 10:
		spawn_interval_seconds -= 0.05
		_asteroid_spawn_timer.wait_time = spawn_interval_seconds
		radius_range.y += 5
		force_range.y += 20
		_difficulty_counter = 0
