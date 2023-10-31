class_name BasicProjectile
extends ProjectileBase
## Most basic Projectile type. Round procedural projectile, no special effects by default
## Projectile is drawn using _draw function - no sprite


@export_category("References")
## The health reference of this Projectile. ProjectileBase does not implement any functionality for HealthExpired.
@export var health_ref : HealthBase
## The DamageApplyer of this Projectile
@export var damage_applyer_ref : DamageApplyer

@export_category("Particles")
## The scene (particles) to instantiate when this Projectile collides with something
@export var collision_death_particle_scene : PackedScene
## The scene (particles) to instantiate when this Projectile dies due to lifespan expiration
@export var lifespan_death_particle_scene : PackedScene
## The scene to instantiate if this Projectile has an AoE modifier greater than 0
@export var aoe_particle_scene : PackedScene


# Privates -------------------------------------------------------------
## Reference to this objects own PackedScene. Used when cloning for Fork/Chain
var my_scene : PackedScene = preload("res://scenes/projectiles/basic_projectile/basic_projectile.tscn")
## The radius of this Projectile in pixels
var radius : float = 3
## the radius value after modifiers have been applied (uses size modifier)
var modified_radius : float


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
	spawn_death_particles()
	queue_free()
	
	
func _on_lifespan_elapsed():
	lifespan_expired = true
	## Apply AoE damage if we died to lifespan timeout 
	if modified_area_of_effect > 0:
		apply_area_damage(damage, [])
	# Spawn the death particles		
	spawn_death_particles()
	queue_free()
	
	
func _on_rigid_body_body_entered(body : Node):
	# Do not collide with the same body twice
	if previously_collided_nodes.has(body):
		return
	previously_collided_nodes.append(body)
	
	# Directly damage the target
	direct_damage_target(body)

	# Check for pierce/fork/chain
	modified_pierce -= 1.0
	if modified_pierce > 0:
		if modified_pierce < 1.0:
			modified_damage *= modified_pierce
	# Fork evaluated after pierce
	elif modified_fork > 0:
		modified_fork -= 1
		spawn_forked_projectiles(self)
		queue_free()
	# No pierce/fork/chain, projectile dies on this collision
	else: 
		# spawn an AoE damage applyer to apply AoE (only when projectile terminates, not on pierce/fork/chain)
		if modified_area_of_effect > 0:
			apply_area_damage(damage, [body])
		health_ref.set_health(0)


func spawn_forked_projectiles(projectile_to_fork : ProjectileBase):
	var parent = projectile_to_fork.get_parent()
	var left_child = projectile_to_fork.clone(my_scene)
	var right_child = projectile_to_fork.clone(my_scene)
	var velocity_magnitude = velocity.length()
	var velocity_angle = velocity.normalized()
	left_child.velocity = left_child.velocity.rotated(-PI / 8.0)
	right_child.velocity = right_child.velocity.rotated(PI / 8.0)
	parent.call_deferred("add_child", left_child)
	parent.call_deferred("add_child", right_child)
		
		
func direct_damage_target(body: Node):
	# Store last collided body for use in particle rotation calculation
	print("Damage: " + str(modified_damage))
	if body is RigidBody2D:
		var offset = global_position - body.global_position 
		body.apply_impulse(velocity * modified_base_mass, offset)
	damage_applyer_ref.apply_damage_to_node(body, damage)
	spawn_direct_damage_particles()
	
	
func _physics_process(_delta):
	# Move the Projectile based on velocity
	position += velocity * _delta


func apply_area_damage(damage_to_apply : float, blacklist_nodes : Array[Node]):
	var aoe_applyer = aoe_scene.instantiate() as AoeDamageApplyer
	aoe_applyer.circle_radius = modified_area_of_effect
	aoe_applyer.damage_to_apply = damage_to_apply
	aoe_applyer.blacklist_bodies = blacklist_nodes
	aoe_applyer.position = position
	aoe_applyer.collision_mask = collision_mask
	get_tree().root.call_deferred("add_child", aoe_applyer)
	spawn_aoe_particles()
	

## Spawns death particles for this Projectile
func spawn_death_particles():
	var particles = lifespan_death_particle_scene.instantiate() as GPUParticles2DOneshotFree
	# Add particle to the root node to prevent despawning when Projectile despawns
	particles.position = position
	get_tree().root.call_deferred("add_child", particles)
	
	
## Spawns direct damage particles for this Projectile
func spawn_direct_damage_particles():
	var particles = collision_death_particle_scene.instantiate() as GPUParticles2DOneshotFree
	# Add particle to the root node to prevent despawning when Projectile despawns
	particles.position = position
	get_tree().root.call_deferred("add_child", particles)


## Spawns Area of Effect particles for this projectile
func spawn_aoe_particles():
	var aoe_particles : AoeParticles = aoe_particle_scene.instantiate() as AoeParticles
	aoe_particles.position = position
	aoe_particles.aoe_radius = modified_area_of_effect
	get_tree().root.call_deferred("add_child", aoe_particles)
