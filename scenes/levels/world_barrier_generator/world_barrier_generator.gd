class_name WorldBarrierGenerator
extends Node

var world_size : Vector2

@export var barrier_width : float

@export var barrier_damage : float


func generate_static_barriers():
	assert(barrier_width > 0 and barrier_damage > 0, "wWorldBarrierGenerator: Params not initialized.")
	
	# Create rigid bodies
	var north_barrier = RigidBody2D.new()
	var south_barrier = RigidBody2D.new()
	var east_barrier = RigidBody2D.new()
	var west_barrier = RigidBody2D.new()
	
	# Set collision layer & mask
	north_barrier.collision_layer = 0x80
	north_barrier.collision_mask = 0x80
	south_barrier.collision_layer = 0x80
	south_barrier.collision_mask = 0x80
	east_barrier.collision_layer = 0x80
	east_barrier.collision_mask = 0x80
	west_barrier.collision_layer = 0x80
	west_barrier.collision_mask = 0x80
	
	# Freeze so they do not move but still generate collisions
	north_barrier.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	south_barrier.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	east_barrier.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	west_barrier.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	north_barrier.freeze = true
	south_barrier.freeze = true
	east_barrier.freeze = true
	west_barrier.freeze = true
	
	# Setup contact monitor to enable collisions
	north_barrier.contact_monitor = true
	north_barrier.max_contacts_reported = 10
	south_barrier.contact_monitor = true
	south_barrier.max_contacts_reported = 10
	east_barrier.contact_monitor = true
	east_barrier.max_contacts_reported = 10
	west_barrier.contact_monitor = true
	west_barrier.max_contacts_reported = 10
	
	# Create collision shape and rectangles 
	var north_collision_shape = CollisionShape2D.new()
	var south_collision_shape = CollisionShape2D.new()
	var east_collision_shape = CollisionShape2D.new()
	var west_collision_shape = CollisionShape2D.new()
	var north_rect = RectangleShape2D.new()
	var south_rect = RectangleShape2D.new()
	var east_rect = RectangleShape2D.new()
	var west_rect = RectangleShape2D.new()
	
	# Set size based on world
	north_rect.size = Vector2(world_size.x, barrier_width)
	south_rect.size = Vector2(world_size.x, barrier_width)
	east_rect.size = Vector2(barrier_width, world_size.y)
	west_rect.size = Vector2(barrier_width, world_size.y)
	
	# attach shapes 
	north_collision_shape.shape = north_rect
	south_collision_shape.shape = south_rect
	east_collision_shape.shape = east_rect	
	west_collision_shape.shape = west_rect
	
	# Add shapes to rigidbodies
	north_barrier.add_child(north_collision_shape)
	south_barrier.add_child(south_collision_shape)
	east_barrier.add_child(east_collision_shape)
	west_barrier.add_child(west_collision_shape)
	
	# adjust position based on world
	var half_barrier_width = barrier_width / 2
	north_barrier.position = Vector2(world_size.x / 2, -half_barrier_width)
	south_barrier.position = Vector2(world_size.x / 2, world_size.y + half_barrier_width)
	east_barrier.position = Vector2(world_size.x + half_barrier_width, world_size.y / 2)
	west_barrier.position = Vector2(-half_barrier_width, world_size.y / 2)
	
	# attach damage applyer to apply damage to collided objects
	var north_damage_applyer = DamageApplyer.new()
	north_damage_applyer.default_damage = barrier_damage
	north_damage_applyer.parent = north_barrier
	north_damage_applyer.uses_cooldown = true
	north_damage_applyer.cooldown_time = 1
	var south_damage_applyer = DamageApplyer.new()
	south_damage_applyer.default_damage = barrier_damage
	south_damage_applyer.parent = south_barrier
	south_damage_applyer.uses_cooldown = true
	south_damage_applyer.cooldown_time = 1
	var east_damage_applyer = DamageApplyer.new()
	east_damage_applyer.default_damage = barrier_damage
	east_damage_applyer.parent = east_barrier
	east_damage_applyer.uses_cooldown = true
	east_damage_applyer.cooldown_time = 1
	var west_damage_applyer = DamageApplyer.new()
	west_damage_applyer.default_damage = barrier_damage
	west_damage_applyer.parent = west_barrier
	west_damage_applyer.uses_cooldown = true
	west_damage_applyer.cooldown_time = 1
	
	# connect the damage signal to collision body_entered
	north_barrier.body_entered.connect(north_damage_applyer.apply_damage_to_node)
	south_barrier.body_entered.connect(south_damage_applyer.apply_damage_to_node)
	east_barrier.body_entered.connect(east_damage_applyer.apply_damage_to_node)
	west_barrier.body_entered.connect(west_damage_applyer.apply_damage_to_node)
	
	# Add damage applyers as children
	north_barrier.add_child(north_damage_applyer)
	south_barrier.add_child(south_damage_applyer)
	east_barrier.add_child(east_damage_applyer)
	west_barrier.add_child(west_damage_applyer)
	
	# Add to the scene
	add_child(north_barrier)
	add_child(south_barrier)
	add_child(east_barrier)
	add_child(west_barrier)
