extends RigidBody2D

## Particle system to play on death
@export var death_particles_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


## Runs when player heath reaches 0. Plays death particles, waits, and restarts the game
func _on_player_death():
	spawn_death_particles()
	

## Spawns death particle system
func spawn_death_particles():
	var particles = death_particles_scene.instantiate() as GPUParticles2DOneshotFree
	# Add particle to the root node to prevent despawning when bullet despawns
	particles.position = position
	get_tree().root.add_child(particles)
