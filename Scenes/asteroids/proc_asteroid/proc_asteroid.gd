class_name ProcAsteroid
extends RigidBody2D
## A procedural asteroid generation script

## The vertices that make up this asteroids's outer shell (polygon)
var vertices = PackedVector2Array()

## The radius (in pixels) of this asteroid
var radius : float

## The amount of vertices that make up this asteroid's polygon
var vertice_count : int

## The randomness applied to each of this asteroid's vertice's position
var jaggedness : float

## The maximum potential radius given the jaggedness value and the base radius
var max_radius : float

## Mass of asteroid is equal to mass_multiplier * radius
var mass_multiplier : float = 1

## Baseline health value - this value is multiplied by the asteroid radius to determine final health
var health_baseline : float = 1

## The asteroid manager to add this asteroid to on spawn
@export var asteroid_manager : AsteroidManager

## The color with which to draw this asteroid
@export var draw_color : Color = Color.WHITE

# The width of the lines used to draw this asteroid
@export var draw_width : float = 2.0

# Asteroids smaller than min_split_radius will die instead of splitting
@export var min_split_radius = 10

# Percentage in which child asteroids radius may vary from exactly half of parent
@export var split_radius_randomness = 0.5

# Random percentage range from 0 to +-'split_velocity_randomness' will be added to child asteroid's velocity
@export var split_velocity_randomness = 0.3

# Child asteroid's angular velocity (radians) will be equal to parents plus a random value in this range
@export var split_angular_velocity_range = PI / 2

# Random value, in radians, to rotate the child asteroid's velocity vector by when spawining (causes child asteroid paths to deviate)
@export var split_velocity_angle_randomness = PI / 16

## The collision polygon of this asteroid
@onready var collision_poly = get_node("CollisionPolygon2D") as CollisionPolygon2D

## The LightOccluder2D of this asteroid
@onready var light_occluder = get_node("LightOccluder2D") as LightOccluder2D

# The health node of this asteroid
@onready var health = get_node("Health") as HealthBase


## Preloaded ProcAsteroid Scene (for spawning children)
var proc_asteroid = preload("res://Scenes/asteroids/proc_asteroid/proc_asteroid.tscn")


## Sets up this object. Must be called after instantiating scene, before adding to scene tree
func setup(_radius: float, _mass_multiplier : float, _vertice_count: int, _jaggedness: float, _asteroid_manager : AsteroidManager):
	radius = _radius
	mass_multiplier = _mass_multiplier
	vertice_count = _vertice_count
	jaggedness = _jaggedness
	max_radius = radius + (radius * jaggedness)
	asteroid_manager = _asteroid_manager
	mass = radius * mass_multiplier


## Calculates vertices, sets CollisionPolygon, and mass of Rigidbody
func _ready():
	# Calculate vertices
	var angle_step = (2 * PI) / vertice_count
	for x in range(vertice_count):
		var jag = 1 + randf_range(-jaggedness, jaggedness)
		var vertex = Vector2(cos(x * angle_step) * radius * jag, sin(x * angle_step) * radius * jag)
		vertices.append(vertex) 
		
	# Update CollisionPolygon with vertices
	collision_poly.polygon = vertices
	# Create OccluderPolygon for light and particle occlusions (enables particles to bounce off with physics)
	var occluder = OccluderPolygon2D.new()
	occluder.polygon = vertices
	light_occluder.occluder = occluder
	
	
	# Set health of asteroid based on size
	health.health = health_baseline * radius
	
	## Add this asteroid to the manager. Used for tracking deletion and efficient querying of all asteroids
	asteroid_manager.add_asteroid(self)


## Draw this asteroid as vector lines
func _draw():
	for i in vertices.size() - 1:
		draw_line(vertices[i], vertices[i+1], draw_color, draw_width, true)
	draw_line(vertices[vertices.size()-1], vertices[0], draw_color, draw_width, true)
	
	
func kill_asteroid():
	if radius >= min_split_radius:
		split_asteroid()
	asteroid_manager.asteroids.erase(self)
	queue_free()
	
func split_asteroid():
		
	# Spawn two new asteroids
	var child_asteroid_1 = generate_child_asteroid()
	# Spawn second child with whatever radius is left over after spawning first 
	var child_asteroid_2 = generate_child_asteroid(radius - child_asteroid_1.radius)
	
	# Solve for positions of new asteroids so they do not touch when spawning
	var child_max_radius = ((radius / 2) + (radius * jaggedness))
	var velocity_vector = linear_velocity.normalized()
	var rotated_vector_1 = velocity_vector.rotated(PI / 2)
	var rotated_vector_2 = velocity_vector.rotated(-PI / 2)
	var spawn_pos_1 = position + (rotated_vector_1 * child_max_radius)
	var spawn_pos_2 = position + (rotated_vector_2 * child_max_radius)
	
	# Set their positions
	child_asteroid_1.position = spawn_pos_1
	child_asteroid_2.position = spawn_pos_2
	
	# Set velocities based on parent asteroids velocity w/ some randomness
	var vel : Vector2 = linear_velocity
	child_asteroid_1.angular_velocity = angular_velocity + randf_range(-split_angular_velocity_range, split_angular_velocity_range)
	child_asteroid_2.angular_velocity = angular_velocity + randf_range(-split_angular_velocity_range, split_angular_velocity_range)
	child_asteroid_1.linear_velocity = vel * randf_range(1 - split_velocity_randomness, 1 + split_velocity_randomness)
	child_asteroid_2.linear_velocity = vel * randf_range(1 - split_velocity_randomness, 1 + split_velocity_randomness)
	child_asteroid_1.linear_velocity = child_asteroid_1.linear_velocity.rotated(randf_range(0, split_velocity_angle_randomness))
	child_asteroid_2.linear_velocity = child_asteroid_2.linear_velocity.rotated(randf_range(0, -split_velocity_angle_randomness))
	
	asteroid_manager.add_child(child_asteroid_1)
	asteroid_manager.add_child(child_asteroid_2)
	
	
## Generates a child asteroid. If radius is provided, it will be used for child radius. If not, a radius will be generated based on parent's radius
func generate_child_asteroid(input_radius : float = 0) -> ProcAsteroid:
	var child = proc_asteroid.instantiate() as ProcAsteroid
	
	# Calculate or set child radius
	var child_radius : float
	if input_radius <= 0:
		child_radius = radius / 2
		child_radius = child_radius * randf_range(1 - split_radius_randomness, 1 + split_radius_randomness)
	else:
		child_radius = input_radius
	# Setup child vertices within +-50% of what parent had
	@warning_ignore("integer_division")
	var child_vertice_count = vertice_count + randf_range(-vertice_count / 2, vertice_count / 2)
	if child_vertice_count < 6:
		child_vertice_count = 6
		
	child.setup(child_radius, mass_multiplier, child_vertice_count, jaggedness, asteroid_manager)
	return child
