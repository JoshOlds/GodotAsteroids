extends Node2D

@export var orbit_ref : OrbitBehavior

func _process(delta):
	position = orbit_ref.request_steering_target(self)
