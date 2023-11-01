extends Node2D
## Sets this Node2D's position to that of the mouse cursor on screen. 
## Can be used to allow for treating the cursor as a Node2D

func _process(_delta):
	# Calculate the mouse position and account for the moving camera
	# Mouse viewport coordinates do not take into account moving camera. (top-left is 0,0 always)
	var viewport = get_viewport()
	var mouse_position : Vector2 = viewport.get_mouse_position()
	var viewport_size : Vector2 = viewport.get_visible_rect().size
	var camera = viewport.get_camera_2d()
	var mouse_coordinates : Vector2 = mouse_position + camera.get_screen_center_position() - (viewport_size / 2)
	position = mouse_coordinates
