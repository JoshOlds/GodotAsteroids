extends RigidBody2D
class_name BasicEnemy

## The target that this BasicEnemy will attempt to attack
@export var target_ref : Node2D

## The distance this BasicEnemy will attempt to hold when attacking target
@export var attack_distance : float


func _ready():
	pass
	#var target_distance_hold : PositioningDistanceHold = $TargetDistanceHold as PositioningDistanceHold
	#target_distance_hold.target_ref = target_ref
	#target_distance_hold.distance = attack_distance
	#
	#var rotation_pid : RotationPid = $RotationPID as RotationPid
	#rotation_pid.target_ref = target_ref
	


