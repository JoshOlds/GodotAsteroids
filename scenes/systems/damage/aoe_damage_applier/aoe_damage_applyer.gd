extends Area2D
class_name AoeDamageApplyer


## The radius of the circle used for collision detection for this AoE Damage Applyer
@export var circle_radius = 1.0

## The collision shape used to overlap bodies
@export var collision_shape : CollisionShape2D

## Damage applyer to apply damage with
@export var damage_applyer : DamageApplyer

## the amount of damage to apply to nodes inside this AoE Applyer
@export var damage_to_apply : float = 0.0

## If true, this object will be deleted after applying damage once.
@export var free_after_damage_apply : bool = true

## Any nodes in this blacklist will not be applied damage. 
@export var blacklist_bodies : Array[Node]

## Counter used to delay applying of damage until after 1 physics update
var _physics_counter = 0

func _ready():
	# set the radius of the circleshape
	var circle_shape : CircleShape2D = collision_shape.shape
	circle_shape.radius = circle_radius


func _physics_process(_delta):
	## Physics process needs at least one frame to update overlapping bodies before trying to dealing damage
	if _physics_counter > 0:
		apply_area_damage()
	else:
		_physics_counter += 1
	
	
## Applies AoE damage to all objects in area. Returns array of nodes that were inside the area
func apply_area_damage() -> Array[Node2D]:
	var overlapping_nodes : Array[Node2D] = []
	overlapping_nodes = get_overlapping_bodies()
	for node in overlapping_nodes:
		if node not in blacklist_bodies:
			damage_applyer.apply_damage_to_node(node, damage_to_apply)
	if free_after_damage_apply:
		queue_free()
	return overlapping_nodes
