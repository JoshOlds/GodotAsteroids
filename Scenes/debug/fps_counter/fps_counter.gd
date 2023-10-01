extends Label

@export var main_camera : Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var viewport_size : Vector2 = get_viewport().get_visible_rect().size
	position = main_camera.get_screen_center_position() - (viewport_size / 2)
	text = str(Engine.get_frames_per_second())
