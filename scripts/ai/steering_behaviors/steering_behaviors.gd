extends Node
class_name  SteeringBehaviors
## An implementation of multiple steering behavior strategies. 
## Steering behaviors may be stacked together to create complex character movement.
## Implementations based on Fernando Bevilacqua's blog: https://code.tutsplus.com/series/understanding-steering-behaviors--gamedev-12732


## Generates a steering force that attempts to move towards the target
static func seek(position : Vector2, velocity : Vector2, target : Vector2, max_steering_force : Vector2) -> Vector2:
	var desired_velocity : Vector2 = (target - position).normalized() * max_steering_force
	var steering = desired_velocity - velocity
	return steering
