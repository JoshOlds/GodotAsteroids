class_name ProcAsteroid
extends RigidBody2D
## A procedural asteroid generation script

## The vertices that make up this asteroids's outer shell (polygon)
var vertices = PackedVector2Array()

## The radius (in pixels) of this asteroid
var radius : int

## The amount of vertices that make up this asteroid's polygon
var vertice_count : int

## The randomness applied to each of this asteroid's vertice's position
var jaggedness : float

## The maximum potential radius given the jaggedness value and the base radius
var max_radius : float

## This value is multiplied by the default mass of this Asteroid
var mass_multiplier : float = 0.1

## Baseline health value - this value is multiplied by the asteroid radius to determine final health
var health_baseline : float = 1

## The color with which to draw this asteroid
@export var draw_color : Color = Color.WHITE

# The width of the lines used to draw this asteroid
@export var draw_width : float = 2.0

## The collision polygon of this asteroid
@onready var collision_poly = get_node("CollisionPolygon2D") as CollisionPolygon2D

## The LightOccluder2D of this asteroid
@onready var light_occluder = get_node("LightOccluder2D") as LightOccluder2D

# The health node of this asteroid
@onready var health = get_node("Health") as HealthBase


## Sets up this object. Must be called after instantiating scene, before adding to scene tree
func setup(_radius: int, _vertice_count: int, _jaggedness: float):
	radius = _radius
	vertice_count = _vertice_count
	jaggedness = _jaggedness
	max_radius = radius + (radius * jaggedness)

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
	
	# Set mass of RigidBody based on asteroid size
	mass = mass * radius * mass_multiplier
	# Set health of asteroid based on size
	health.health = health_baseline * radius

## Draw this asteroid as vector lines
func _draw():
	for i in vertices.size() - 1:
		draw_line(vertices[i], vertices[i+1], draw_color, draw_width, true)
	draw_line(vertices[vertices.size()-1], vertices[0], draw_color, draw_width, true)
