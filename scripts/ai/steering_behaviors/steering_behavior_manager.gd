extends Node
class_name SteeringBehaviorManager

@export_category("References")
## The RigidBody2D this steering manager will apply accelerations to
@export var rigidbody_ref : RigidBody2D

@export_category("Steering Behavior Configuration")
## The maximum velocity allowed for this object.
## Steering behaviors will not apply accelerations that would exceed this velocity
@export var max_velocity : float = 0
## The maximum acceleration allowed. End result of all steering behaviors may not apply accelerations exceeding this acceleration.
@export var max_acceleration : float = 0
## If true, if no other Steering Behavior outputs accelerations, the settle behavior will attempt to bring the body to rest.
@export var settle_enabled : bool = true
## If true, the Seek behavior will be processed processed and resulting accelerations applied each frame.
@export var seek_enabled : bool = false
## If true, the Persuit behavior will be processed and resulting accelerations applied each frame.
@export var persuit_enabled : bool = false
## If True, the Avoid behavior will be processed and resulting accelerations applied each frame.
@export var avoid_enabled : bool = false
## If True, Wander behavior will inject errors into the final steering acceleration to produce randomness.
@export var wander_enabled : bool = false

@export_group("Seek Behavior Parameters")
## The targets for the Seek behavior.
@export var seek_targets : Array[Node2D] = []
## If true, all Seek accelerations (from multiple targets) will be averaged together.
## This prevents multiple targets from 'outweighing' a lesser amount of other steering behaviors.
@export var average_seek_accelerations : bool = true
## Velocity damping will be applied linearly when target is within the Seek Damping Radius
@export var seek_damping_radius : float = 0
## If true, the seek behavior will attempt to damped velocity based on current velocity and max acceleration.
## Helps prevent overshoot dynamically, but is more cpu intensive operation.
@export var acceleration_based_damping : bool = true


@export_group("Persuit Behavior Parameters")
## The targets for the Persuit behavior.
@export var persuit_targets : Array[RigidBody2D] = []
## If true, all Persuit accelerations (from multiple targets) will be averaged together.
## This prevents multiple targets from 'outweighing' a lesser amount of other steering behaviors.
@export var average_persuit_accelerations : bool = true

@export_group("Avoid Behavior Parameters")
## The targets for the Avoid behavior.
@export var avoid_targets : Array[Node2D] = []
## The radius in which to attempt to avoid the target. Avoidance force is scaled linearly across this radius.
## Being closer to the target will result in higher Avoidance force.
@export var avoid_radius : float = 100
## If true, all Avoid accelerations (from multiple targets) will be averaged together.
## This prevents multiple targets from 'outweighing' a lesser amount of other steering behaviors.
@export var average_avoid_accelerations : bool = true

@export_group("Wander Behavior Parameters")
@export var wander_circle_distance = 50
@export var wander_angle_step = PI / 180
@export var wander_velocity = 0
var wander_circle_heading : float = 0
@export var wander_debug_ref : Node2D
@export var wander_debug_ref2 : Node2D


## The sum of all steering accelerations for this physics frame
var _desired_steering_acceleration : Vector2


func _physics_process(delta):
	
	_desired_steering_acceleration = Vector2.ZERO
	# Execute enabled steering functions
	if seek_enabled:
		_seek(delta)
	if persuit_enabled:
		_persuit(delta)
	if avoid_enabled:
		_avoid(delta)
	if wander_enabled:
		_wander(delta)
	
	if _desired_steering_acceleration == Vector2.ZERO and settle_enabled:
		_settle(delta)
		
	# Truncate steering acceleration if it exceeds maximum acceleration
	if _desired_steering_acceleration.length() > max_acceleration:
		var steering_acceleration_direction = _desired_steering_acceleration.normalized()
		_desired_steering_acceleration = steering_acceleration_direction * max_acceleration
	
	# Apply the acceleration as a force scaled for mass
	var steering_force = _desired_steering_acceleration * rigidbody_ref.mass
	rigidbody_ref.apply_central_force(steering_force)


func _seek(delta):
	if seek_targets.is_empty():
		return
	var seek_accelerations : Vector2 = Vector2.ZERO
	for target in seek_targets:
		var position_error = target.global_position - rigidbody_ref.global_position
		var position_error_distance = position_error.length()
		var desired_velocity = position_error.normalized() * max_velocity
		var current_velocity = rigidbody_ref.linear_velocity.length()
		var desired_acceleration = Vector2.ZERO
		
		# Seek Damping Radius ----------
		if position_error_distance < seek_damping_radius:
			desired_velocity *= position_error_distance / seek_damping_radius
		# ------------------------------
		# Acceleration Based Damping -------------------------------------------
		if acceleration_based_damping:
			# Stopping distance = Velocity^2 / 2*Acceleration
			var stopping_distance = pow(current_velocity, 2) / (2 * max_acceleration)
			if position_error_distance <= stopping_distance and stopping_distance > 0:
				desired_acceleration = rigidbody_ref.linear_velocity.normalized() * -1.0 * max_acceleration
			else:
				desired_acceleration = (desired_velocity - rigidbody_ref.linear_velocity) / delta
		# ---------------------------------------------------------------------
		else:
			desired_acceleration = (desired_velocity - rigidbody_ref.linear_velocity) / delta
		seek_accelerations += desired_acceleration
	if average_seek_accelerations:
		seek_accelerations /= len(seek_targets)
	_desired_steering_acceleration += seek_accelerations
		
		
func _persuit(delta):
	if persuit_targets.is_empty():
		return
	var persuit_accelerations : Vector2 = Vector2.ZERO
	for target in persuit_targets:
		var position_error = target.global_position - rigidbody_ref.global_position
		var time_scalar =  position_error.length() / max_velocity
		var target_future_position = target.global_position + (target.linear_velocity * time_scalar)
		var future_position_error = target_future_position - rigidbody_ref.global_position
		var desired_velocity = future_position_error.normalized() * max_velocity
		var desired_acceleration = (desired_velocity - rigidbody_ref.linear_velocity) / delta
		persuit_accelerations += desired_acceleration
	if average_persuit_accelerations:
		persuit_accelerations /= len(persuit_targets)
	_desired_steering_acceleration += persuit_accelerations
	
	
func _avoid(delta):
	if avoid_targets.is_empty():
		return
	var avoid_accelerations : Vector2 = Vector2.ZERO
	var avoid_count = 0 # Track a count for avoids that were processed, as not all targets will be processed if they are far enough away
	for target in avoid_targets:
		var position_error = target.global_position - rigidbody_ref.global_position
		if position_error == Vector2.ZERO:
			position_error.x = 0.1
		var position_error_distance = position_error.length()
		if position_error_distance < avoid_radius:
			var avoid_direction = position_error.normalized() * -1
			var desired_velocity = avoid_direction * max_velocity * ((avoid_radius - position_error_distance) / avoid_radius)
			var desired_acceleration = (desired_velocity - rigidbody_ref.linear_velocity) / delta
			avoid_accelerations += desired_acceleration
			avoid_count += 1
	if average_avoid_accelerations and avoid_count > 0:
		avoid_accelerations /= avoid_count
	_desired_steering_acceleration += avoid_accelerations
	

func _settle(delta):
	var desired_velocity = Vector2.ZERO
	var desired_acceleration = (desired_velocity - rigidbody_ref.linear_velocity) / delta
	_desired_steering_acceleration += desired_acceleration
	
	
func _wander(delta):
	wander_circle_heading += randf_range(-wander_angle_step, wander_angle_step)
	var forward_vector = rigidbody_ref.linear_velocity.normalized()
	
	if forward_vector == Vector2.ZERO:
		forward_vector = Vector2(0, 1)
	var circle_position = rigidbody_ref.global_position + (forward_vector * wander_circle_distance * 3)
	var circle_forward_vector = Vector2(cos(wander_circle_heading), sin(wander_circle_heading))
	var target = circle_position + (circle_forward_vector * wander_circle_distance * 2)
	var position_error = target - rigidbody_ref.global_position
	var desired_velocity = position_error.normalized() * wander_velocity
	var desired_acceleration = (desired_velocity - rigidbody_ref.linear_velocity) / delta
	_desired_steering_acceleration += desired_acceleration
	wander_debug_ref.set_deferred("position", circle_position)
	wander_debug_ref2.set_deferred("position", target)

	
	

	
	
