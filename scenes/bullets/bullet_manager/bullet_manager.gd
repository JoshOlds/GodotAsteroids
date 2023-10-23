class_name BulletManager
extends Node
## Tracks all bullets currently in the game, and handles cleaning up any bullets that move off-screen

## Interval (in seconds) for cleaning up off-screen bullets
@export var off_world_bullet_cleanup_interval : float = 1.0

## Array that stores all bullets currently instantiated in scene
var bullet_array : Array[BulletBase]

## Size of the game world. Must be set by parent
var world_size : Vector2

## Timer for clearing offscreen bullets
var _cleanup_timer : Timer


func _ready():
	# set up cleanup timer
	_cleanup_timer = Timer.new()
	add_child(_cleanup_timer)
	_cleanup_timer.wait_time = off_world_bullet_cleanup_interval
	#_cleanup_timer.timeout.connect(delete_off_world_bullets)
	_cleanup_timer.start()
	

func add_bullet(bullet : BulletBase):
	bullet_array.append(bullet)


func remove_bullet(bullet : BulletBase):
	bullet_array.erase(bullet)

	
## Delete all bullets that are outside the world
func delete_off_world_bullets():
	assert(world_size.x > 0 and world_size.y > 0, "BulletManager: World Size has not yet been set up. Please set when instantiating.") 
	var bullets_to_keep : Array[BulletBase] = []
	for bullet in bullet_array:
		if (bullet.position.x < 0 
			or bullet.position.x > world_size.x
			or bullet.position.y < 0
			or bullet.position.y > world_size.y):
				bullet.queue_free()
		else:
			bullets_to_keep.append(bullet)
	bullet_array = bullets_to_keep