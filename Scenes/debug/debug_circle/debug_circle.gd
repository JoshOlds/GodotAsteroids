class_name DebugCircle
extends Node2D

@export var radius : float = 10

@export var color : Color = Color.RED

func _draw():
	draw_circle(position, radius, color)
