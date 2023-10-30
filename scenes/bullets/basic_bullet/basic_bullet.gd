class_name BasicBullet
extends BulletBase

## The radius of this bullet in pixels
@export var radius : float = 3
## the radius value after modifiers have been applied (uses size modifier)
var modified_radius : float


func _ready():
	super()

	## Modify size
	modified_radius = radius * modified_size

	# Move self forward based on new radius (so we don't self collide with player)
	var forward_vec = Vector2(cos(rotation), sin(rotation))
	position += modified_radius * forward_vec

	# Create a circle shape and add to collision shape child
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = modified_radius
	$CollisionShape2D.shape = circle_shape
	
	# Setup the circle drawer
	$CircleDrawer.radius = modified_radius
	$CircleDrawer.color = Color.WHITE
	

func _on_health_expired(damage_source_node : Node):
	super._on_health_expired(damage_source_node)
	
func _on_hit():
	print("Child Virtual!")
