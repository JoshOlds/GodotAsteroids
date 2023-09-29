class_name GunManager
extends Node2D

@export var bullet_scene : PackedScene

@export var bullet_manager : BulletManager

@export var spawn_rigid_body : RigidBody2D

@export var bullet_spawn_impulse : float = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("mouse_left_click"):
		spawn_bullet(bullet_spawn_impulse)

func spawn_bullet(force : float):
	var bullet = bullet_scene.instantiate() as BasicBullet
	
	var spawn_position = $BulletSpawnLocation.global_position
	var spawn_rotation = $BulletSpawnLocation.global_rotation
	var spawn_velocity : Vector2 = spawn_rigid_body.linear_velocity
	var forward_vec =  Vector2(cos(spawn_rotation), sin(spawn_rotation))
	var spawn_offset_position : Vector2 = spawn_position + (bullet.radius * forward_vec)
	
	bullet.position = spawn_offset_position
	bullet.linear_velocity = spawn_velocity
	bullet.bullet_manager = bullet_manager
	bullet.apply_central_impulse(forward_vec * force)
	#bullet_manager.add_bullet(bullet)
	bullet_manager.add_child(bullet)
