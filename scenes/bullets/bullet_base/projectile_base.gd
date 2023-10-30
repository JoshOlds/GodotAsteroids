class_name ProjectileBase
extends Area2D
## Base class for all Projectiles. Makes minimal assumptions about projectile implementation.
## Handles storing and updating modifier values, Timer for Lifespan, and Crit Roll calculations


# ------------- Modifiers --------------------------------------------------------------------------
@export_category("Modifiers")
## Mass of this Projectile. Overwrites the rigidBody mass on _ready()
@export var base_mass : float = 1.0
## The base_mass value after modifiers have been applied
var modified_base_mass : float

## Base damage of this Projectile. Damage is modified by crit and by children before being applied to target.
@export var damage : float = 1.0
## The damage value after modifiers have been applied
var modified_damage : float

## Critical Damage Chance chance of this Projectile. A 'critical' hit applies (damage * (crit_damage_modifier)) damage.
@export var crit_chance : float = 0.03
## The crit_chance value after modifiers have been applied
var modified_crit_chance : float

## Critical Damage Multiplier of this Projectile. 
@export var crit_damage_multiplier : float = 3.0
## The crit_damage value after modifiers have been applied
var modified_crit_damage_multiplier : float

## Size of this Projectile. ProjectileBase does not include any drawing information for Projectile - size is expected to be utilized by derived classes when drawing
@export var size : float = 1.0
## The size value after modifiers have been applied
var modified_size : float

## Area of Effect of this Projectile. Damage will be applied to any body within the AoE radius on collision
@export var area_of_effect : float = 0.0
## The area_of_effect value after modifiers have been applied
var modified_area_of_effect : float
## Scene used to spawn an AoE Damage Applyer. Spawning packed scene is faster than generating all the nodes in code
var aoe_scene = preload("res://scenes/systems/damage/aoe_damage_applier/aoe_damage_applyer.tscn")

## Lifespan of this Projectile (in seconds). Child classes must implement functionality for when Lifespan Elapses 
@export var lifespan : float = 10.0
## The lifespan value after modifiers have been applied
var modified_lifespan : float


# Privates ----------------------------------------------------------------------------------------
## The current velocity of this projectile. 
var velocity : Vector2

## Whether or not this Projectile rolled a crit for its damage
var is_crit : bool = false

## Timer for this Projectiles lifespan. Calls _lifespan_elapsed() when timer elapses
var lifespan_timer : Timer
## True if this Projectile's lifespan elapsed
var lifespan_expired : bool = false

## The Modifiers that this ProjectileBase will use to calculate modified values
var modifiers : Modifiers


func _ready():
	# Check for missing modifiers - soft error if missing
	if modifiers == null:
		push_warning("ProjectileBase: Modifiers is null on _ready(). No modifiers will be processed. Please assign modifiers before adding to scene.")
		modifiers = Modifiers.new()
	apply_modifiers()
	
	# Roll for crit
	is_crit = roll_for_crit()
	if is_crit:
		damage = damage * modified_crit_damage_multiplier

	# Set up lifespan timer
	lifespan_timer = Timer.new()
	lifespan_timer.name = "LifespanTimer"
	add_child(lifespan_timer)
	lifespan_timer.wait_time = modified_lifespan
	lifespan_timer.one_shot = true
	lifespan_timer.timeout.connect(_on_lifespan_elapsed)
	lifespan_timer.start()
	
	
## Default for ProjectileBase - moves Node based on velocity
func _physics_process(delta):
	position += velocity * delta
	

## Updates the modifier 'modified_xxx' values. Only run on _ready() as we don't want Projectile mods changing while they are alive
func apply_modifiers():
	modified_base_mass = modifiers.mass_mod.get_modified_value(base_mass)
	modified_damage = modifiers.damage_mod.get_modified_value(damage)
	modified_crit_chance = modifiers.crit_chance_mod.get_modified_value(crit_chance)
	modified_crit_damage_multiplier = modifiers.crit_damage_mod.get_modified_value(crit_damage_multiplier)
	modified_size = modifiers.size_mod.get_modified_value(size)
	modified_area_of_effect = modifiers.area_of_effect_mod.get_modified_value(area_of_effect)
	modified_lifespan = modifiers.lifespan_mod.get_modified_value(lifespan)
	
	
## Executes when lifespan timer elapses. Default behavior is to queue_free() and throw a warning.
func _on_lifespan_elapsed():
	push_warning("ProjectileBase: _on_lifespan_elapsed() called from parent. Be sure to override this in your child Projectile class.")
	queue_free()
	
	
## Rolls for crit chance and returns true if crit, false otherwise
func roll_for_crit() -> bool:
	var crit_roll = randf()
	if modified_crit_chance >= crit_roll:
		return true
	return false

	

	

