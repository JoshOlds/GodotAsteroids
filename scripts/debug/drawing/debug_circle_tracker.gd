extends DebugCircle
class_name DebugCircleTracker

@export var track_target_ref : Node2D

func _process(delta):
	position = track_target_ref.position

