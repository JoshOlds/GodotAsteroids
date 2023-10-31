class_name CollisionCooldown
extends Node

## This signal is broadcast when a body_entered signal is received and that particular body is not on cooldown
signal body_entered(node : Node)

## Time (in seconds) to cooldown
@export var cooldown_time : float = 1.0 

## The rigidbody to connect to body_entered signal
@export var rigidbody_to_connect : RigidBody2D

## After cleanup_interval collisions, the cleanup_dictionary() function will be called
@export var cleanup_interval : int = 100

## Dictionary to store nodes and their last received time. Used to calculate cooldown
var body_dict = {}

## Counter used to track when to cleanup dictionary
var _cleanup_count = 0


func _ready():
	rigidbody_to_connect.body_entered.connect(_on_rigid_body_body_entered)


func _on_rigid_body_body_entered(node : Node):
	var now = Time.get_ticks_msec()
	var node_id = node.get_instance_id()
	var last_collision_time = body_dict.get(node_id)
	
	# If we have not hit this body yet, store the current time and emit signal
	if last_collision_time == null:
		body_dict[node_id] = now
		body_entered.emit(node)
	# Otherwise, if the elapsed_time is greater than cooldown time, emit the signal and store new collision time
	else:
		var elapsed_time_ms = now - last_collision_time
		var elapsed_time_seconds = elapsed_time_ms / 1000
		if elapsed_time_seconds > cooldown_time:
			body_dict[node_id] = now
			body_entered.emit(node)
	
	# Cleanup the dictionary if we have had enough collisions
	_cleanup_count += 1
	if _cleanup_count > cleanup_interval:
		_cleanup_count = 0
		cleanup_dictionary()
			
## Erases any entrys in the dictionary that are	older than the cooldown time
func cleanup_dictionary():
	var now = Time.get_ticks_msec()
	var keys = body_dict.keys()
	for key in keys:
		var collision_time = body_dict[key]
		if ((now - collision_time) / 1000) > cooldown_time:
			body_dict.erase(key)
