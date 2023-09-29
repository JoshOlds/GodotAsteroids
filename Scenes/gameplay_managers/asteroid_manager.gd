class_name AsteroidManager
extends Node

## Array that holds all active asteroids
var asteroids : Array[ProcAsteroid]

func add_asteroid(asteroid : ProcAsteroid):
	asteroids.append(asteroid)

func remove_asteroid(asteroid : ProcAsteroid):
	asteroids.erase(asteroid)
	
func _process(_delta):
	#clear_invalid_asteroids()
	pass
	
func clear_invalid_asteroids():
	var invalid_asteroids : Array[ProcAsteroid] = []
	for node in asteroids:
		if is_instance_valid(node) == false:
			invalid_asteroids.append(node)
	for node in invalid_asteroids:
		asteroids.erase(node)
			
