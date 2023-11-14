extends Node
class_name RotationPid

## the Rigidbody that this RotationPID will control (Apply rotational torques to)
@export var rigidbody_ref : RigidBody2D

## The target that this RotationPID will attempt to rotate towards
@export var target_ref : Node2D

## The maximum torque able to be applied when rotating
@export var rotational_torque : float

@export_category("PID Values")
## Proportional coefficient PID
@export var kp : float = 0.5
## Integral coefficient PID
@export var ki : float = 0.01
## Derivative coefficient PID
@export var kd : float = 0.2
## Maximum integral value of PID
@export var integral_max : float = 200
## Maximum derivative value of PID
@export var derivative_max : float = 5
## Previous error of the PID
var prev_error : float = 0
## Ongoing integral value of PID
var integral : float = 0


func _physics_process(delta):
	rotate_to_target(delta)


## Rotates the rigidbody_ref towards the target - intended to be called once per _physics_process
func rotate_to_target(delta : float):
	
	# Calculate rotation setpoint for PID
	var angle_to_target = rigidbody_ref.global_position.angle_to_point(target_ref.global_position)
	var angle_error = (angle_to_target - rigidbody_ref.rotation)
	
	# Normalize the angle to -PI to PI
	if angle_error < -PI:
		angle_error += 2 * PI
	elif angle_error > PI:
		angle_error -= 2 * PI
	
	# Calculate torque to apply using PID
	var torque_to_apply = _rotation_pid(delta, angle_error) * rotational_torque
	rigidbody_ref.apply_torque_impulse(torque_to_apply * delta)
	
	
## PID algorithm for Rotation control
func _rotation_pid(delta : float, error : float) -> float:
	var p_out = kp * error
	
	integral += error * delta
	var i_out = ki * integral
	
	var derivative = (error - prev_error) / delta
	var d_out = kd * derivative
	d_out = clampf(d_out, -derivative_max, derivative_max)
	
	var output = p_out + i_out + d_out
	
	clampf(integral, -integral_max, integral_max)
	prev_error = error
	return output
