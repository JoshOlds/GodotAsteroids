class_name GunManager
extends Node2D
## Handle spawning of bullets on player input.
##
## TODO: This class should probably turn into a base class for all 'projectile weapon' style guns

## PackedScene of bullet to spawn when shooting
@export var bullet_scene : PackedScene

## Bullet manager all new bullets will be added to
@export var bullet_manager : BulletManager

# RigidBody of the parent of this bullet. Used to get values such as linear_velocity of the parent
@export var spawn_rigid_body : RigidBody2D

## Impulse to apply to bullet on spawn
@export var bullet_spawn_impulse : float = 500

## The rate to fire, in bullets per second, when holding down the fire button
@export var fire_rate = 5

## If true, the gun is on cooldown (cannot shoot)
var _on_cooldown : bool = false

## Timer used to update gun cooldown
var _cooldown_timer : Timer


func _ready():
	# set up cooldown timer
	_cooldown_timer = Timer.new()
	_cooldown_timer.one_shot = true
	_cooldown_timer.timeout.connect(_reset_cooldown)
	add_child(_cooldown_timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("mouse_left_click"):
		shoot()
		
		
## Callback function to reset the fire cooldown. Meant to be called from cooldown timer
func _reset_cooldown():
	_on_cooldown = false
		

# Spawns a bullet if off cooldown
func shoot():
	if not _on_cooldown:
		# Go on cooldown and set timer
		_on_cooldown = true
		_cooldown_timer.wait_time = 1.0 / fire_rate
		_cooldown_timer.start()
		spawn_bullet()
		
	
# Spawns a bullet. Instantiates bullet scene and applys velocity and forces	
func spawn_bullet():
	var bullet = bullet_scene.instantiate() as BasicBullet
	
	var spawn_position = $BulletSpawnLocation.global_position
	var spawn_rotation = $BulletSpawnLocation.global_rotation
	var spawn_velocity : Vector2 = spawn_rigid_body.linear_velocity
	var forward_vec =  Vector2(cos(spawn_rotation), sin(spawn_rotation))
	var spawn_offset_position : Vector2 = spawn_position + (bullet.radius * forward_vec)
	
	bullet.position = spawn_offset_position
	bullet.linear_velocity = spawn_velocity
	bullet.bullet_manager = bullet_manager
	bullet.apply_central_impulse(forward_vec * bullet_spawn_impulse)
	bullet_manager.add_child(bullet)
