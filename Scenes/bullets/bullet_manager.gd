class_name BulletManager
extends Node

## Array that stores all bullets currently instantiated in scene
var bullet_array : Array[BulletBase]

## When a bullet exceeds this X position boundary it will be deleted
@export var bullet_x_boundary : Vector2

## When a bullet exceeds this Y position boundary it will be deleted
@export var bullet_y_boundary : Vector2


func add_bullet(bullet : BulletBase):
	bullet_array.append(bullet)

func remove_bullet(bullet : BulletBase):
	bullet_array.erase(bullet)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	delete_off_screen_bullets()
	

func delete_off_screen_bullets():
	var bullets_to_delete : Array[BulletBase] = []
	for bullet in bullet_array:
		if (bullet.position.x < bullet_x_boundary.x 
			or bullet.position.x > bullet_x_boundary.y
			or bullet.position.y < bullet_y_boundary.x
			or bullet.position.y > bullet_y_boundary.y):
				bullets_to_delete.append(bullet)

	for bullet in bullets_to_delete:
		bullet.queue_free()
		bullet_array.erase(bullet)
				
	

