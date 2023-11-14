extends Node2D
class_name PositioningDistanceHold
## This Node2D class will move itself to a position that is <distance> away from target with respect to the 
## <source_ref>'s position

## The target Node2D that this Node2D will attempt to hold distance from
@export var target_ref : Node2D

@export var source_ref : Node2D

## The distance to hold from target
@export var distance : float


func _process(delta):
	var target_to_source_direction = (source_ref.position - target_ref.position).normalized()
	var desired_position_offset = target_to_source_direction * distance
	var desired_position = target_ref.position + desired_position_offset
	global_position = desired_position
