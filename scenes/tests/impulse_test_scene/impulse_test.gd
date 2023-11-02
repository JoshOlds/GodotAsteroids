extends RigidBody2D

@export var impulse_vector : Vector2
var count = 0
func _ready():
	for i in 2: await get_tree().physics_frame
	apply_central_impulse(impulse_vector)

func _process(delta):
	print("Linear Velocity: " + str(linear_velocity))
