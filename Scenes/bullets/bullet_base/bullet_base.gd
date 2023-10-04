class_name BulletBase
extends RigidBody2D
## Base class for all Bullets. Handles the concepts of:
## Detecting collisions and applying damage

## The damage this bullet will deal
@export var damage : float

## RigidBody2D collision max contacts reported (see docs)
@export var max_contacts_reported_export : int = 10

## The scene (particles) to instantiate when this bullet dies
@export var death_particle_scene : PackedScene

## Bullet manager this bullet will be childed to on spawn. Bullet manager handles cleaning up off-screen bullets
@export var bullet_manager : BulletManager

## The health of this bullet. Bullet will die when health reaches zero
@onready var health = get_node("Health") as HealthBase

## The DamageApplyer of this bullet
@onready var damage_applyer = get_node("DamageApplyer") as DamageApplyer

## The last node that collided with this bullet
var last_collision_node : Node2D

## The velocity of this node on the previous physics step
var previous_velocity : Vector2 = Vector2(0, 0)

## The normal vector of the previous collision
var previous_collision_normal : Vector2 = Vector2(0, 0)

## Flag to queue death of this bullet. Death is queued from Physics process to allow for final raycasts after collision
var queue_death = false


func _ready():
	max_contacts_reported = max_contacts_reported_export
	contact_monitor = true
	body_entered.connect(_on_rigid_body_body_entered)
	bullet_manager.add_bullet(self) 

	
func _on_rigid_body_body_entered(body : Node):
	last_collision_node = body
	damage_applyer.apply_damage_to_node(body, damage)
	health.set_health(0)
	
	
func _on_death():
	bullet_manager.remove_bullet(self)
	queue_death = true
	
	
func _physics_process(_delta):
	previous_velocity = linear_velocity
	

	if queue_death:
		# Raycast towards collision target and get normal vector
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(position, last_collision_node.position)
		query.exclude = [self] # Dont raycast collide on self
		var result = space_state.intersect_ray(query)
		if not result.is_empty():
			previous_collision_normal = result["normal"]
		spawn_death_particles()
		queue_free()
	
	
func spawn_death_particles():
	var particles = death_particle_scene.instantiate() as GPUParticles2DOneshotFree
	# Set particle angle (direction of scatter) to the normal of the previous collision
	particles.rotation = previous_collision_normal.angle()
	# Add particle to the root node to prevent despawning when bullet despawns
	particles.position = position
	get_tree().root.add_child(particles)
	
