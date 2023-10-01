class_name CollisionForceDamageApplyer
extends Node

## The RigidBody who's body_entered events will be handled by this CollisionForceDamageApplyer
@export var parent_rigid_body : RigidBody2D

## The DamageApplyer that will be used to apply damage
@export var damage_applyer : DamageApplyer

## Damage applied = impact_force * damage_multiplier. Adjust depending on expected magnitude of collisions
@export var damage_multiplier : float = 0.001

func _ready():
	parent_rigid_body.contact_monitor = true
	parent_rigid_body.max_contacts_reported = 10
	parent_rigid_body.body_entered.connect(_on_rigid_body_body_entered)
	

func _on_rigid_body_body_entered(body : Node):
	if not body is RigidBody2D:
		return
	body = body as RigidBody2D
	
	var velocity_differential = parent_rigid_body.linear_velocity - body.linear_velocity
	var smaller_mass : float
	if parent_rigid_body.mass < body.mass:
		smaller_mass = parent_rigid_body.mass
	else:
		smaller_mass = body.mass
		
	var impact_force = smaller_mass * velocity_differential.length()
	
	var damage = impact_force * damage_multiplier
	damage_applyer.apply_damage_to_node(body, damage)

