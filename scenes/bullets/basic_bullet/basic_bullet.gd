class_name BasicBullet
extends BulletBase
## Most basic bullet type. Round procedural projectile, no special effects by default
## Bullet is drawn using _draw function - no sprite


@export_category("Particles")
## The scene (particles) to instantiate when this bullet collides with something
@export var collision_death_particle_scene : PackedScene
## The scene (particles) to instantiate when this bullet dies due to lifespan expiration
@export var lifespan_death_particle_scene : PackedScene
## The scene to instantiate if this bullet has an AoE modifier greater than 0
@export var aoe_particle_scene : PackedScene


# Privates -------------------------------------------------------------
## The radius of this bullet in pixels
var radius : float = 3
## the radius value after modifiers have been applied (uses size modifier)
var modified_radius : float

## The last node that collided with this bullet. Used to rotate collision particles to ricochet off target
var last_collision_node : Node2D
var last_collision_position : Vector2
## The normal vector of the previous collision
var previous_collision_normal : Vector2 = Vector2(0, 0)

var queue_death: bool = false


func _ready():
	super()

	## Modify size
	modified_radius = radius * modified_size

	# Move self forward based on new radius (so we don't self collide with player)
	var forward_vec = Vector2(cos(rotation), sin(rotation))
	position += modified_radius * forward_vec

	# Create a circle shape and add to collision shape child
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = modified_radius
	$CollisionShape2D.shape = circle_shape
	
	# Setup the circle drawer
	$CircleDrawer.radius = modified_radius
	$CircleDrawer.color = Color.WHITE
	

func _on_health_expired(damage_source_node : Node):
	queue_death = true
	
	
func _on_lifespan_elapsed():
	lifespan_expired = true
	## Apply AoE damage if we died to lifespan timeout 
	if modified_area_of_effect > 0:
		apply_area_damage(damage, [])
	queue_death = true
	
	
func _on_rigid_body_body_entered(body : Node):
	# Store last collided body for use in particle rotation calculation
	last_collision_node = body
	last_collision_position = last_collision_node.position
	damage_applyer_ref.apply_damage_to_node(body, damage)

	# spawn an AoE damage applyer to apply AoE
	if modified_area_of_effect > 0:
		apply_area_damage(damage, [last_collision_node])

	# Kill this bullet
	health_ref.set_health(0)

	
func _physics_process(_delta):
	# Move the bullet based on velocity
	position += velocity * _delta
	
	if queue_death:
		# Only calculate if we died from collision, not lifespan expired
		if not lifespan_expired:
			# Raycast towards collision target and get normal vector. Used for rotating death particles away from collision
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(position, last_collision_position)
			query.exclude = [self] # Dont raycast collide on self
			var result = space_state.intersect_ray(query)
			if not result.is_empty():
				previous_collision_normal = result["normal"]

		# Spawn the death particles		
		call_deferred("spawn_death_particles")
		call_deferred("queue_free")
	

func apply_area_damage(damage_to_apply : float, blacklist_nodes : Array[Node]):
	var aoe_applyer = aoe_scene.instantiate() as AoeDamageApplyer
	aoe_applyer.circle_radius = modified_area_of_effect
	aoe_applyer.damage_to_apply = damage_to_apply
	aoe_applyer.blacklist_bodies = blacklist_nodes
	aoe_applyer.damage_applyer.group_blacklist.append("player_projectiles")
	aoe_applyer.damage_applyer.group_blacklist.append("player")
	aoe_applyer.position = position
	aoe_applyer.collision_mask = collision_mask
	get_tree().root.call_deferred("add_child", aoe_applyer)
	

## Spawns death particles for this bullet
func spawn_death_particles():
	var particles : GPUParticles2DOneshotFree
	## Different particle effects depending on if we collided or died from lifespan elapsed
	if lifespan_expired:
		particles = lifespan_death_particle_scene.instantiate() as GPUParticles2DOneshotFree
	else:
		particles = collision_death_particle_scene.instantiate() as GPUParticles2DOneshotFree
		# Set particle angle (direction of scatter) to the normal of the previous collision
		particles.rotation = previous_collision_normal.angle()
	# Add particle to the root node to prevent despawning when bullet despawns
	particles.position = position
	get_tree().root.call_deferred("add_child", particles)
	
	if aoe_particle_scene != null and modified_area_of_effect > 0:
			var aoe_particles : AoeParticles = aoe_particle_scene.instantiate() as AoeParticles
			aoe_particles.position = position
			aoe_particles.aoe_radius = modified_area_of_effect
			get_tree().root.call_deferred("add_child", aoe_particles)
	


