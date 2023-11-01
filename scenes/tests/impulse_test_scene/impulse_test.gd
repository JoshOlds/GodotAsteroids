extends RigidBody2D

@export var impulse_vector : Vector2

func _ready():
	apply_central_impulse(impulse_vector)

func _process(delta):
	print("Linear Velocity: " + str(linear_velocity))
