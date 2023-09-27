extends Node

@export var asteroid_generator : AsteroidGenerator

@export var spawn_interval_seconds : float = 2.0

@export var radius_range : Vector2i = Vector2i(30, 200)

@export var vertices_range : Vector2i = Vector2i(6, 30)

@export var jaggedness_range : Vector2 = Vector2(0.03, 0.3)

@export var force_range : Vector2i = Vector2i(20000, 50000)

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.connect("timeout", self._on_timer_timeout)
	timer.wait_time = spawn_interval_seconds
	add_child(timer)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_timer_timeout():
	var radius = randf_range(30, 300)
	var vertices = randf_range(6, 30)
	var jaggedness = randf_range(0.03, 0.3)
	var force = randf_range(10000, 30000)
	asteroid_generator.spawn_asteroid_at_random_location_on_path(radius, vertices, jaggedness, force)
	#asteroid_generator.check_position_is_clear(100, Vector2(1920/2, 1080/2))
