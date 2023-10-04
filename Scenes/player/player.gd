extends RigidBody2D

## Reference to Health system for this player
@export var health_ref : HealthBase

## Particle system to play on death
@export var death_particles_scene : PackedScene

func _ready():
	health_ref.health_changed.connect(_on_health_changed)
	health_ref.health_expired.connect(_on_player_death)

	# Call deferred so that we don't emit before the UI is funnly initialized
	call_deferred("_on_health_changed", health_ref.health, health_ref.health, health_ref.max_health)

## Runs when player heath reaches 0. Plays death particles, waits, and restarts the game
func _on_player_death():
	SignalBroker.player_death.emit()
	spawn_death_particles()
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_health_changed(previous_value : float, new_value : float, max_health : float):
	SignalBroker.player_health_changed.emit(previous_value, new_value, max_health)
	

## Spawns death particle system
func spawn_death_particles():
	var particles = death_particles_scene.instantiate() as GPUParticles2DOneshotFree
	# Add particle to the root node to prevent despawning when bullet despawns
	particles.position = position
	get_tree().root.add_child(particles)


	
