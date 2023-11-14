extends Node
class_name OrbitGenerator
## Generates a Vector2 position that orbits a given target_node.
## Handles generating multiple target positions equally spaced around the orbit of the target.
## Orbits are only calculated on request, so this node incurs no runtime overhead.

## The target Node2D that this OrbitBehavior will generate Vector2 positions in orbit around.
@export var target_node : Node2D

## The orbit radius, in pixels, around the target.
@export var orbit_radius : float = 10

## The speed at which the orbit positions will rotate around the target_node. In Radians/Second
@export var orbit_rotation_speed : float = 0

## Dictionary of all nodes that have requested an orbit position. Used to calculate even spacing between orbit positions with no overlap.
var registered_nodes_dict : Dictionary = {}

## Count of how many nodes have requested an orbit position.
var registered_node_count = 0

## The time, in milliseconds, of the first orbit position request.
var start_time : int = 0


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED


## Provides an orbit position. 
func request_orbit_position(requesting_node : Node) -> Vector2:
	if registered_node_count == 0:
		start_time = Time.get_ticks_msec()
	# Register this node if it isn't already
	if not registered_nodes_dict.has(requesting_node):
		registered_nodes_dict[requesting_node] = registered_node_count
		registered_node_count += 1
	var sec_since_start : float = (Time.get_ticks_msec() - start_time) / 1000.0
	var current_orbit_angle = orbit_rotation_speed * sec_since_start
	var node_index = registered_nodes_dict[requesting_node]
	var orbit_angle_offset = 0
	if node_index > 0:
		orbit_angle_offset = ((2 * PI) / (registered_node_count)) * node_index
	var target_angle = current_orbit_angle + orbit_angle_offset
	var position_offset = Vector2(sin(target_angle) * orbit_radius, cos(target_angle) * orbit_radius)
	var orbit_pos = target_node.position + position_offset
	return orbit_pos
	

## Clears all registered nodes and resets the count. 
func reset():
	registered_nodes_dict.clear()
	registered_node_count = 0
	
	
