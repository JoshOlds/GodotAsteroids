extends Node2D

@export var camera_target : Node 

@onready var viewport : Viewport = get_viewport()

var temp = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	viewport.canvas_transform = Transform2D(0, Vector2(camera_target.position.x, camera_target.position.y))
	pass
