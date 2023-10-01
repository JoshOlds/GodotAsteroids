class_name BulletManager
extends Node
## Tracks all bullets currently in the game, and handles cleaning up any bullets that move off-screen

## Array that stores all bullets currently instantiated in scene
var bullet_array : Array[BulletBase]

## Size of the game world. Must be set by parent
var world_size : Vector2

func add_bullet(bullet : BulletBase):
	bullet_array.append(bullet)

func remove_bullet(bullet : BulletBase):
	bullet_array.erase(bullet)


func _process(_delta):
	delete_off_screen_bullets()
	

func delete_off_screen_bullets():
	assert(world_size.x > 0 and world_size.y > 0, "BulletManager: World Size has not yet been set up. Please set when instantiating.")
	
	var bullets_to_delete : Array[BulletBase] = []
	for bullet in bullet_array:
		if (bullet.position.x < 0 
			or bullet.position.x > world_size.x
			or bullet.position.y < 0
			or bullet.position.y > world_size.y):
				bullets_to_delete.append(bullet)

	for bullet in bullets_to_delete:
		bullet.queue_free()
		bullet_array.erase(bullet)
				
	

