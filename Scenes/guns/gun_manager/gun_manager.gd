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

# ---------- Gun Modifiers ---------------------
## Causes this GunManager to spawn multiple projectiles when firing
@export var multiple_projectiles : int = 1
## multiple_projectiles value after modifiers have been applied
var modified_multiple_projectiles : int

## Impulse to apply to bullet on spawn
@export var bullet_spawn_impulse : float = 1000
## bullet_spawn_impulse value after modifiers have been applied
var modified_bullet_spawn_impulse : float

## The rate to fire, in bullets per second, when holding down the fire button
@export var fire_rate : float = 1
## fire_rate value after modifiers have been applied
var modified_fire_rate : float

## Recoil impulse to apply when firing this gun
@export var recoil : float = 500
## recoil value after modifiers have been applied
var modified_recoil : float

## Default spread value (rad). Used for seperation angle between multiple projectiles
@export var spread : float = PI / 18.0
## spread value after modifiers have been applied
var modified_spread : float

## Inaccuracy values over 0 inject error into the spawn angle of each projectile
@export var inaccuracy : float = PI / 18
## inaccuracy value after modifiers have been applied
var modified_inaccuracy : float

## ----------- Privates ----------------------

@onready var last_fire_time = Time.get_ticks_msec()

## True if fire button is currently pressed
var _fire_pressed : bool = false


func _ready():
	# Get initial modifier values
	_on_weapon_modifiers_changed()

	# Connect to WeaponModifiers signal
	weapon_modifiers.weapon_modifiers_changed.connect(_on_weapon_modifiers_changed)


## Process is used to handle inputs
func _process(_delta):
	## TODO - put this on callbacks instead of every frame
	if Input.is_action_pressed("mouse_left_click"):
		_fire_pressed = true
	else:
		_fire_pressed = false


func _physics_process(_delta):
	if _fire_pressed:
		shoot()

		
## Updates all Weapon Modifiers on signal
func _on_weapon_modifiers_changed():
	modified_multiple_projectiles = multiple_projectiles + weapon_modifiers.multiple_projectiles_mod
	modified_bullet_spawn_impulse = weapon_modifiers.spawn_impulse_mod.get_modified_value(bullet_spawn_impulse)
	modified_fire_rate = weapon_modifiers.fire_rate_mod.get_modified_value(fire_rate)
	modified_recoil = weapon_modifiers.recoil_mod.get_modified_value(recoil)
	modified_spread = weapon_modifiers.spread_mod.get_modified_value(spread)
	modified_inaccuracy = weapon_modifiers.inaccuracy_mod.get_modified_value(inaccuracy)


## Spawns a bullet if off cooldown
func shoot():
	var now = Time.get_ticks_msec()
	if ((now - last_fire_time) > ((1.0 / modified_fire_rate) * 1000)):
		last_fire_time = now
		spawn_bullets()


## Applies recoil to the parent rigidbody
func apply_recoil(recoil_angle : float, recoil_value : float):
	var recoil_forward_vector = Vector2(cos(recoil_angle), sin(recoil_angle))
	var recoil_vector = recoil_forward_vector * recoil_value
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
	bullet.weapon_modifiers = weapon_modifiers
	bullet.apply_central_impulse(forward_vec * modified_bullet_spawn_impulse)
	bullet_manager.add_child(bullet)
	
	var recoil_angle = spawn_rotation - PI
	apply_recoil(recoil_angle, modified_recoil)


## Spawns bullets accounting for multiple projectiles modifier. Calls spawn_bullet() per bullet instantiated
func spawn_bullets():
	var projectile_count : int = modified_multiple_projectiles
	var projectile_seperation = modified_spread
	var original_spawn_position = $BulletSpawnLocation.global_position
	var parent_to_spawn_vector = original_spawn_position - global_position

	# Spawn the first projectile outside of loop, since first is handled a bit differently
	# If Odd number of projectiles, one fires down the middle. If Even, they are offset
	var first_bullet_angle_offset = 0
	if projectile_count > 1:
		if projectile_count % 2 == 0:
			first_bullet_angle_offset = -1 * projectile_seperation / 2

	var inaccuracy_angle = randf_range(-modified_inaccuracy, modified_inaccuracy)
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
			spawn_rotation = global_rotation + right_angle_offset + first_bullet_angle_offset + randf_range(-modified_inaccuracy, modified_inaccuracy)
			spawn_bullet(spawn_position, spawn_rotation)
		else:
			left_angle_offset -= projectile_seperation
			rotated_parent_to_spawn_vector = parent_to_spawn_vector.rotated(left_angle_offset + first_bullet_angle_offset)
			spawn_position = global_position + (rotated_parent_to_spawn_vector)
			spawn_rotation = global_rotation + left_angle_offset + first_bullet_angle_offset + randf_range(-modified_inaccuracy, modified_inaccuracy)
			spawn_bullet(spawn_position, spawn_rotation)
				
