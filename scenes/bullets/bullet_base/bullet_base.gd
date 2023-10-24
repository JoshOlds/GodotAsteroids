class_name BulletBase
extends RigidBody2D
## Base class for all Bullets. Handles the concepts of:
## Detecting collisions and applying damage


## RigidBody2D collision max contacts reported (see docs)
@export var max_contacts_reported_export : int = 10

## The scene (particles) to instantiate when this bullet collides with something
@export var collision_death_particle_scene : PackedScene
## The scene (particles) to instantiate when this bullet dies due to lifespan expiration
@export var lifespan_death_particle_scene : PackedScene

## Bullet manager this bullet will be childed to on spawn. Bullet manager handles cleaning up off-screen bullets
@export var bullet_manager : BulletManager

## The health of this bullet. Bullet will die when health reaches zero
@onready var health = get_node("Health") as HealthBase

## The DamageApplyer of this bullet
@onready var damage_applyer = get_node("DamageApplyer") as DamageApplyer

## Timer used to destroy this bullet after lifespan expires
var lifespan_timer : Timer
## True if this bullet died by expired lifespan rather than collision
var lifespan_expired : bool = false

## The Modifiers that this BulletBase will use to calculate modified values
var modifiers : Modifiers

## The last node that collided with this bullet
var last_collision_node : Node2D
var last_collision_position : Vector2

## The velocity of this node on the previous physics step
var previous_velocity : Vector2 = Vector2(0, 0)

## The normal vector of the previous collision
var previous_collision_normal : Vector2 = Vector2(0, 0)

## Flag to queue death of this bullet. Death is queued from Physics process to allow for final raycasts after collision
var queue_death = false

# ------------- Modifiers -------------------------
## Mass of this bullet. Overwrites the rigidBody mass on _ready()
@export var base_mass : float = 1.0
## The base_mass value after modifiers have been applied
var modified_base_mass : float

## Damage that this bullet applies on collision with another body.
@export var damage : float = 1.0
## The damage value after modifiers have been applied
var modified_damage : float

## Critical Damage Chance chance of this bullet. A 'critical' hit applies (damage * (crit_damage_modifier)) damage.
@export var crit_chance : float = 0.03
## The crit_chance value after modifiers have been applied
var modified_crit_chance : float

## Critical Damage Multiplier of this bullet. 
@export var crit_damage_multiplier : float = 3.0
## The crit_damage value after modifiers have been applied
var modified_crit_damage_multiplier : float

## Size of this bullet. BulletBase does not include any drawing information for bullet - size is expected to be utilized by derived classes when drawing
@export var size : float = 1.0
## The size value after modifiers have been applied
var modified_size : float

## Area of Effect of this bullet. Damage will be applied to any body within the AoE radius on collision
@export var area_of_effect : float = 0.0
## The crit_damage value after modifiers have been applied
var modified_area_of_effect : float
## Scene used to spawn an AoE Damage Applyer. Spawning packed scene is faster than generating all the nodes in code
var aoe_scene = load("res://scenes/systems/damage/aoe_damage_applier/aoe_damage_applyer.tscn")

## Lifespan of this bullet (in seconds). Bullet will de-spawn after lifespan expires. 
@export var lifespan : float = 10.0
## The crit_damage value after modifiers have been applied
var modified_lifespan : float



func _ready():
	# Check for missing modifiers - soft error if missing
	if modifiers == null:
		push_warning("bulletBase: Modifiers is null on _ready(). No modifiers will be processed. Please assign modifiers before adding to scene.")
		modifiers = Modifiers.new()
	apply_modifiers()

	# Modifiers on _ready()
	mass = modified_base_mass

	# Set up Rigidbody for monitoring & hook up signal
	max_contacts_reported = max_contacts_reported_export
	contact_monitor = true
	body_entered.connect(_on_rigid_body_body_entered)

	# add to bullet manager for tracking (and deletion off screen)
	#bullet_manager.add_bullet(self) 

	# Set up lifespan timer
	lifespan_timer = Timer.new()
	lifespan_timer.name = "LifespanTimer"
	add_child(lifespan_timer)
	lifespan_timer.wait_time = modified_lifespan
	lifespan_timer.one_shot = true
	lifespan_timer.timeout.connect(_on_lifespan_expired)
	lifespan_timer.start()


## Updates the modifier 'modified_xxx' values. Only run on _ready() as we don't want bullet mods changing while they are alive
func apply_modifiers():
	modified_base_mass = modifiers.mass_mod.get_modified_value(base_mass)
	modified_damage = modifiers.damage_mod.get_modified_value(damage)
	modified_crit_chance = modifiers.crit_chance_mod.get_modified_value(crit_chance)
	modified_crit_damage_multiplier = modifiers.crit_damage_mod.get_modified_value(crit_damage_multiplier)
	modified_size = modifiers.size_mod.get_modified_value(size)
	modified_area_of_effect = modifiers.area_of_effect_mod.get_modified_value(area_of_effect)
	modified_lifespan = modifiers.lifespan_mod.get_modified_value(lifespan)
	
	
func _on_rigid_body_body_entered(body : Node):
	# only process collision if we did not collide with another
	if  body.is_in_group("player_projectiles"):
		return

	# Roll for crit
	var damage_to_apply = get_crit_result()

	# Apply damage to collided body - 
	last_collision_node = body
	last_collision_position = last_collision_node.position
	damage_applyer.apply_damage_to_node(body, damage_to_apply)

	# spawn an AoE damage applyer to apply AoE
	if modified_area_of_effect > 0:
		apply_area_damage(damage_to_apply, [last_collision_node])

	# Kill this bullet
	health.set_health(0)

	
func _on_health_expired(_damage_source_node : Node):
	queue_death = true


## Executes when lifespan timer elapses
func _on_lifespan_expired():
	lifespan_expired = true
	# Apply AoE damage if we died to lifespan timeout 
	var damage_to_apply = get_crit_result()
	if modified_area_of_effect > 0:
		apply_area_damage(damage_to_apply, [])
	# Queue death for this object
	queue_death = true
	
	
func _physics_process(_delta):
	previous_velocity = linear_velocity
	
	if queue_death:
		#bullet_manager.remove_bullet(self)
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
	

## Applies AoE damage to all objects in area. Returns array of nodes that were inside the area
func apply_area_damage(damage_to_apply : float, blacklist_nodes : Array[Node]):
	#print("Area!")
	var aoe_applyer = aoe_scene.instantiate() as AoeDamageApplyer
	aoe_applyer.circle_radius = modified_area_of_effect
	aoe_applyer.damage_to_apply = damage_to_apply
	aoe_applyer.blacklist_bodies = blacklist_nodes
	aoe_applyer.damage_applyer.group_blacklist.append("player_projectiles")
	aoe_applyer.position = position
	get_tree().root.call_deferred("add_child", aoe_applyer)
	

## Spawns death particles for this bullet
func spawn_death_particles():
	var particles : GPUParticles2DOneshotFree
	# Different particle effects depending on if we collided or died from lifespan elapsed
	if lifespan_expired:
		particles = lifespan_death_particle_scene.instantiate() as GPUParticles2DOneshotFree
	else:
		particles = collision_death_particle_scene.instantiate() as GPUParticles2DOneshotFree
		# Set particle angle (direction of scatter) to the normal of the previous collision
		particles.rotation = previous_collision_normal.angle()
	# Add particle to the root node to prevent despawning when bullet despawns
	particles.position = position
	get_tree().root.call_deferred("add_child", particles)
	

## Rolls for crit chance and returns the resulting damage value
func get_crit_result() -> float:
	var crit_roll = randf()
	var damage_result = modified_damage
	if (modified_crit_chance >= crit_roll):
		damage_result = damage_result * modified_crit_damage_multiplier
	return damage_result
