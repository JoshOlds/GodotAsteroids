class_name GPUParticles2DOneshotFree
extends GPUParticles2D
## Base class for GPUParticles2D that automatically deletes the particle system node once a single lifetime has expired


func _ready():
	one_shot = true
	emitting = true
	var free_timer = Timer.new()
	add_child(free_timer)
	free_timer.one_shot = true
	free_timer.wait_time = lifetime
	free_timer.timeout.connect(cleanup)
	free_timer.start()


func cleanup():
	queue_free()
