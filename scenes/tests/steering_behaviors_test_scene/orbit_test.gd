extends Node2D

@export var orbit_ref : OrbitGenerator

func _process(_delta):
	position = orbit_ref.request_orbit_position(self)
