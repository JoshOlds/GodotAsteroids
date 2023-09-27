class_name DebugCircle
extends Node2D

@export var radius : float = 10

@export var color : Color = Color.RED

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _draw():
	draw_circle(position, radius, color)
