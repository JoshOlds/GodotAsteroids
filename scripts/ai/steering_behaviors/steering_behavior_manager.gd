extends Node
class_name SteeringBehaviorManager

@export_category("References")
## The RigidBody2D this steering manager will apply forces to
@export var rigidbody_ref : RigidBody2D

@export_category("Shared Steering Parameters")
@export var max_velocity : float = 0
@export var max_steering_force : float = 0

@export_category("Seek Behavior Parameters")
@export var seek_enabled : bool = false
@export var seek_targets : Array[Node2D] = []
@export var seek_damping_radius : float = 0
## If true, all Seek forces (from multiple targets) will be averaged together.
## This prevents multiple targets from 'outweighing' a lesser amount of other steering behaviors.
@export var average_seek_forces : bool = true

## The sum of all steering forces for this physics frame
var steering_force : Vector2


func _physics_process(delta):
	# Execute enabled steering functions
	steering_force = Vector2.ZERO
	if seek_enabled:
		_seek(delta)
		
	# Truncate steering force if it exceeds maximum force
	if steering_force.length() > max_steering_force:
		var steering_force_direction = steering_force.normalized()
		steering_force = steering_force_direction * max_steering_force
	
	# Apply the force
	print("Force: " + str(steering_force))
	rigidbody_ref.apply_central_force(steering_force)


func _seek(delta):
	var seek_forces : Vector2 = Vector2.ZERO
	for target in seek_targets:
		var position_error = target.position - rigidbody_ref.position
		var position_error_distance = position_error.length()
		print("Distance Error: " + str(position_error_distance))
		var desired_velocity = position_error.normalized() * max_velocity
		if position_error_distance < seek_damping_radius:
			desired_velocity *= position_error_distance / seek_damping_radius
		print("Desired Velocity: " + str(desired_velocity))
		var desired_force = ((desired_velocity - rigidbody_ref.linear_velocity) * rigidbody_ref.mass) / delta
		seek_forces += desired_force
	if average_seek_forces:
		seek_forces /= len(seek_targets)
	steering_force += seek_forces
		
		
		
	
