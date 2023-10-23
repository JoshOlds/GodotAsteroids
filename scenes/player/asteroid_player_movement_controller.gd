class_name AsteroidPlayerMovementController
extends Node

## Linear Control Modes - How input affects player linear motion (W,A,S,D)
enum LinearControlMode {
	CARDINAL, ## Control inputs will move player in absolute direction (up is always up)
	HEADING ## Control inputs will move player with respect to player heading (up is forward with respect to player direction)
}

## Rotational Control Modes - How input affects player rotation/heading
enum RotationalControlMode {
	CURSOR_STEER ## Player will auto-rotate to face the mouse cursor
}

@export var player_rigid_body : RigidBody2D

@export var main_camera : Camera2D

@export_category("Motion & Thrust")
## Player Thrust in linear directions
@export var linear_thrust : float = 1000
## Max player speed in pixels/s
@export var max_speed : float = 500 
## Torque force used to rotate towards cursor
@export var rotational_torque : float = 5000
## Rotational velocity to count as 'over-rotating'. Controller will attempt to apply torque to stop rotation when exceeding this threshold
@export var over_rotating_velocity_threshold : float = PI * 8

@export_category("Control Modes")
## Which LinearControlMode type to use 
@export var linear_control_mode : LinearControlMode = LinearControlMode.CARDINAL
		
## Which RotationalControlType to use
@export var rotational_control_mode : RotationalControlMode = RotationalControlMode.CURSOR_STEER

# Flags specifying if the linear speed limits are currently exceeded
var heading_forward_limit_exceeded : bool = false
var heading_backward_limit_exceeded : bool = false
var heading_left_limit_exceeded : bool = false
var heading_right_limit_exceeded : bool = false
var cardinal_up_limit_exceeded : bool = false
var cardinal_right_limit_exceeded : bool = false
var cardinal_left_limit_exceeded : bool = false
var cardinal_down_limit_exceeded : bool = false

# Player Motion variables - updated every physics cycle
## Player's current rotation angle
var player_rotation : float
## Player's current forward vector
var player_forward_vector : Vector2 
## Player's current backward vector 
var player_backward_vec : Vector2
## Player's current right vector
var player_right_vec : Vector2
## Player's current left vector
var player_left_vec: Vector2
## Player's current linear velocity
var player_linear_velocity : Vector2


# PID Variables - Mouse Rotation
@export_category("Mouse Rotate - PID Values")
## Proportional coefficient of Mouse Rotate PID
@export var kp : float = 0.5
## Integral coefficient of Mouse Rotate PID
@export var ki : float = 0.01
## Derivative coefficient of Mouse Rotate PID
@export var kd : float = 0.2
## Maximum integral value of Mouse Rotate PID
@export var integral_max : float = 200
## Maximum derivative value of Mouse Rotate PID
@export var derivative_max : float = 5
## Previous error of the Mouse Rotate PID
var prev_error : float = 0
## Ongoing integral value of Mouse PID
var integral : float = 0


## Core control loop 
func _physics_process(delta):
	update_player_motion_variables()
	update_speed_limit_flags()
	apply_linear_motions()
	apply_rotations(delta)
	
	
## Updates all player motion variables - intended to be called once per _physics_process
func update_player_motion_variables():
	player_rotation = player_rigid_body.transform.get_rotation()
	player_forward_vector = Vector2(cos(player_rotation), sin(player_rotation))
	player_backward_vec = player_forward_vector * -1
	player_right_vec = Vector2(cos(player_rotation + (PI / 2)), sin(player_rotation + (PI / 2)))
	player_left_vec = player_right_vec * -1
	player_linear_velocity = player_rigid_body.linear_velocity
		
		
## Calculates and updates speed limit flags - intended to be called once per _physics_process
func update_speed_limit_flags():
	# Clear speed limits
	heading_forward_limit_exceeded = false
	heading_backward_limit_exceeded = false
	heading_left_limit_exceeded = false
	heading_right_limit_exceeded = false
	cardinal_up_limit_exceeded = false
	cardinal_right_limit_exceeded = false
	cardinal_left_limit_exceeded = false
	cardinal_down_limit_exceeded = false

	# Calculate if we have exceeded speed limits
	# If our velocity vector magnitude exceeds the max speed, check which directions are exceeded
	if player_linear_velocity.length() > max_speed:
		# If the dot product of the directional vector and the linear velocity is >0, then thrust in that direction will increase speed (meaning we cannot keep applying thrust in that direction)
		# Heading speed limits
		if player_forward_vector.dot(player_linear_velocity) > 0:
			heading_forward_limit_exceeded = true
		if player_backward_vec.dot(player_linear_velocity) > 0:
			heading_backward_limit_exceeded = true
		if player_left_vec.dot(player_linear_velocity) > 0:
			heading_left_limit_exceeded = true
		if player_right_vec.dot(player_linear_velocity) > 0:
			heading_right_limit_exceeded = true
		
		# Cardinal speed limits
		if Vector2.UP.dot(player_linear_velocity) > 0:
			cardinal_up_limit_exceeded = true
		if Vector2.RIGHT.dot(player_linear_velocity) > 0:
			cardinal_right_limit_exceeded = true
		if Vector2.DOWN.dot(player_linear_velocity) > 0:
			cardinal_down_limit_exceeded = true
		if Vector2.LEFT.dot(player_linear_velocity) > 0:
			cardinal_left_limit_exceeded = true
	
	
## Route to the correct linear control mode method - intended to be called once per _physics_process
func apply_linear_motions():
	match (linear_control_mode):
		LinearControlMode.CARDINAL:
			control_cardinal_mode()
		LinearControlMode.HEADING:
			control_heading_mode()

		
## Executes Heading Mode control - applies thrusts based on Player's relative heading and control inputs
func control_heading_mode():
	# Apply thrust if limits are not exceeded
	if Input.is_action_pressed("move_forward") and not heading_forward_limit_exceeded:
		player_rigid_body.apply_central_force(player_forward_vector * linear_thrust)
	if Input.is_action_pressed("move_backward") and not heading_backward_limit_exceeded:
		player_rigid_body.apply_central_force(player_backward_vec * linear_thrust)
	if Input.is_action_pressed("strafe_left") and not heading_left_limit_exceeded:
		player_rigid_body.apply_central_force(player_left_vec * linear_thrust)
	if Input.is_action_pressed("strafe_right") and not heading_right_limit_exceeded:
		player_rigid_body.apply_central_force(player_right_vec * linear_thrust)
		
	
## Executes Cardinal Mode control - applies thrusts based on absolute cardinal directions
func control_cardinal_mode():
	# Apply thrust if limits are not exceeded
	if Input.is_action_pressed("move_forward") and not cardinal_up_limit_exceeded:
		player_rigid_body.apply_central_force(Vector2.UP * linear_thrust)
	if Input.is_action_pressed("move_backward") and not cardinal_down_limit_exceeded:
		player_rigid_body.apply_central_force(Vector2.DOWN * linear_thrust)
	if Input.is_action_pressed("strafe_left") and not cardinal_left_limit_exceeded:
		player_rigid_body.apply_central_force(Vector2.LEFT * linear_thrust)
	if Input.is_action_pressed("strafe_right") and not cardinal_right_limit_exceeded:
		player_rigid_body.apply_central_force(Vector2.RIGHT * linear_thrust)
	
		
## Applies rotational forces. Calls correct rotation method based on control scheme and over-rotation detection - intended to be called once per _physics_process
func apply_rotations(delta : float):
	# Check if we are over-rotating
	var over_rotating = player_rigid_body.angular_velocity > over_rotating_velocity_threshold or player_rigid_body.angular_velocity < -over_rotating_velocity_threshold
	# If so, do not allow control (natural damping will occur due to angular damping of player
	if over_rotating:
		_clear_pid()
	# Route to selected RotationalControlMode method
	match rotational_control_mode:
		RotationalControlMode.CURSOR_STEER:
			rotate_to_cursor(delta)
		
		
## Rotates the player to face the cursor using PID - intended to be called once per _physics_process
func rotate_to_cursor(delta : float):
	
	# Calculate the mouse position and account for the moving camera
	# Mouse viewport coordinates do not take into account moving camera. (top-left is 0,0 always)
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	var viewport_size : Vector2 = get_viewport().get_visible_rect().size
	var mouse_coordinates : Vector2 = mouse_position + main_camera.get_screen_center_position() - (viewport_size / 2)
	
	# Get the angle to the cursor
	var angle_to_cursor = player_rigid_body.global_position.angle_to_point(mouse_coordinates)
	var angle_error = (angle_to_cursor - player_rotation)
	# Normalize the angle to -PI to PI
	if angle_error < -PI:
		angle_error += 2 * PI
	elif angle_error > PI:
		angle_error -= 2 * PI
	
	# Calculate torque to apply using PID
	var torque_to_apply = _rotation_pid(delta, angle_error) * rotational_torque
	player_rigid_body.apply_torque(torque_to_apply)
	
	
## PID algorithm for Mouse Rotate control scheme
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
	
	
## Resets PID values - prevents runaway i and d terms when control is disabled
func _clear_pid():
	integral = 0
	prev_error = 0
	
