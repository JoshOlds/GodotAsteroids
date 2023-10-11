class_name GunManager
extends Node2D
## Handle spawning of bullets on player input.
##
## TODO: This class should probably turn into a base class for all 'projectile weapon' style guns

## PackedScene of bullet to spawn when shooting
@export var bullet_scene : PackedScene

## Bullet manager all new bullets will be added to
@export var bullet_manager : BulletManager

## RigidBody of the parent of this bullet. Used to get values such as linear_velocity of the parent
@export var spawn_rigid_body : RigidBody2D

## The WeaponModifiers object used to determine modifiers for this GumManager
@export var weapon_modifiers : WeaponModifiers

## Impulse to apply to bullet on spawn
@export var bullet_spawn_impulse : float = 1000

## The rate to fire, in bullets per second, when holding down the fire button
@export var fire_rate = 1

## Recoil impulse to apply when firing this gun
@export var recoil = 500

## Inaccuracy values over 0 inject error into the spawn angle of each projectile
@export var inaccuracy = PI / 18

## Timer used to update gun cooldown
var _cooldown_timer : CooldownTimer

# --------- Gun Defaults ----------
## Default spread value (rad). Used for seperation angle between multiple projectiles in standard guns
var spread : float = PI / 18.0

# --------- Modifiers -------------
## Causes this GunManager to spawn multiple projectiles when firing
@export var multiple_projectiles_mod : int = 1

## Multiplier for the cooldown (time between shots)
@export var fire_rate_mod = 1.0

## Multiplier for the bullet spread when firing multiple projectiles. No effect for single projectile gun
@export var spread_mod : float = 1.0

## Multiplier for inaccuracy. Inaccuracy over 0 inject error into the fire angle of projectiles
@export var inaccuracy_mod : float = 1.0


func _ready():
	# set up cooldown timer
	_cooldown_timer = CooldownTimer.new()
	_cooldown_timer.cooldown_time = (1.0 / (fire_rate * fire_rate_mod))
	add_child(_cooldown_timer)

	# Connect to WeaponModifiers signal
	weapon_modifiers.weapon_modifiers_changed.connect(_on_weapon_modifiers_changed)


func _physics_process(_delta):
	if Input.is_action_pressed("mouse_left_click"):
		shoot()
		
## Updates all Weapon Modifiers on signal
func _on_weapon_modifiers_changed():
	multiple_projectiles_mod = weapon_modifiers.multiple_projectiles_mod
	fire_rate_mod = weapon_modifiers.fire_rate_mod
	spread_mod = weapon_modifiers.spread_mod


## Spawns a bullet if off cooldown
func shoot():
	if not _cooldown_timer.is_on_cooldown():
		# Go on cooldown and set timer
		_cooldown_timer.wait_time = (1.0 / (fire_rate * fire_rate_mod))
		_cooldown_timer.start_cooldown()
		spawn_bullets()
		apply_recoil(recoil)


## Applies recoil to the parent rigidbody
func apply_recoil(recoil_amount : float):
	var parent_rotation = spawn_rigid_body.rotation
	var reverse_vec = Vector2(cos(parent_rotation), sin(parent_rotation)) * -1
	var recoil_vector = reverse_vec * recoil_amount
	spawn_rigid_body.apply_central_impulse(recoil_vector)
		
	
## Instantiates a bullet. Applies impulse to bullet
func spawn_bullet(spawn_position : Vector2, spawn_rotation : float):
	var bullet = bullet_scene.instantiate() as BasicBullet
	var spawn_velocity : Vector2 = spawn_rigid_body.linear_velocity
	var forward_vec =  Vector2(cos(spawn_rotation), sin(spawn_rotation))
	var spawn_offset_position : Vector2 = spawn_position + (bullet.radius * forward_vec)
	
	bullet.position = spawn_offset_position
	bullet.linear_velocity = spawn_velocity
	bullet.bullet_manager = bullet_manager
	bullet.apply_central_impulse(forward_vec * bullet_spawn_impulse)
	bullet_manager.add_child(bullet)


## Spawns bullets accounting for multiple projectiles modifier. Calls spawn_bullet() per bullet instantiated
func spawn_bullets():
	var projectile_count : int = multiple_projectiles_mod
	var projectile_seperation = spread * spread_mod
	var original_spawn_position = $BulletSpawnLocation.global_position
	var parent_to_spawn_vector = original_spawn_position - global_position

	# Spawn the first projectile outside of loop, since first is handled a bit differently
	# If Odd number of projectiles, one fires down the middle. If Even, they are offset
	var first_bullet_angle_offset = 0
	if projectile_count > 1:
		if projectile_count % 2 == 0:
			first_bullet_angle_offset = -1 * projectile_seperation / 2

	var inaccuracy_angle = randf_range(-inaccuracy, inaccuracy)
	var rotated_parent_to_spawn_vector = parent_to_spawn_vector.rotated(first_bullet_angle_offset)
	var spawn_position = global_position + (rotated_parent_to_spawn_vector)
	var spawn_rotation = global_rotation + first_bullet_angle_offset + inaccuracy_angle
	spawn_bullet(spawn_position, spawn_rotation)

	# Spawn the rest of the bullets in a loop. Increment angle offset each iteration
	var left_angle_offset = 0
	var right_angle_offset = 0
	for x in projectile_count - 1:
		if x % 2 == 0:
			right_angle_offset += projectile_seperation
			rotated_parent_to_spawn_vector = parent_to_spawn_vector.rotated(right_angle_offset + first_bullet_angle_offset)
			spawn_position = global_position + (rotated_parent_to_spawn_vector)
			spawn_rotation = global_rotation + right_angle_offset + first_bullet_angle_offset + randf_range(-inaccuracy, inaccuracy)
			spawn_bullet(spawn_position, spawn_rotation)
		else:
			left_angle_offset -= projectile_seperation
			rotated_parent_to_spawn_vector = parent_to_spawn_vector.rotated(left_angle_offset + first_bullet_angle_offset)
			spawn_position = global_position + (rotated_parent_to_spawn_vector)
			spawn_rotation = global_rotation + left_angle_offset + first_bullet_angle_offset + randf_range(-inaccuracy, inaccuracy)
			spawn_bullet(spawn_position, spawn_rotation)
				
