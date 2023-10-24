class_name DebugCircle
extends Node2D

@export var radius : float = 10

@export var color : Color = Color.RED

@export var streak : bool = true

@onready var previous_global_position : Vector2 = global_position


func _draw():
	var previous_local_position = to_local(previous_global_position)
	if not streak:
		draw_circle(position, radius, color)
	else:
		draw_circle(previous_local_position, radius, color)
		draw_circle(position, radius, color)
		draw_line(previous_local_position, position, color, 2.0 * radius, true)
		previous_global_position = global_position
