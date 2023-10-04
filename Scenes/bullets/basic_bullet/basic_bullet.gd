class_name BasicBullet
extends BulletBase

## The radius of this bullet in pixels
@export var radius : float = 3

func _ready():
	super()
	# Create a circle shape and add to collision shape child
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = radius
	$CollisionShape2D.shape = circle_shape
	
	# Setup the circle drawer
	$CircleDrawer.radius = radius
	$CircleDrawer.color = Color.WHITE
	
func _on_health_expired(damage_source_node : Node):
	super._on_health_expired(damage_source_node)
