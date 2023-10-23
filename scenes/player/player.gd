extends RigidBody2D

## Reference to Health system for this player
@export var health_ref : HealthBase

## Particle system to play on death
@export var death_particles_scene : PackedScene

@export_category("Debug")
@export var debug_start_experience = 0

## Player experience system
@onready var experience : PlayerExperience = PlayerExperience.new()


func _ready():
	# Debug
	experience.add_experience(debug_start_experience)
	
	# Connect to signals
	health_ref.health_changed.connect(_on_health_changed)
	health_ref.health_expired.connect(_on_health_expired)
	SignalBroker.score_changed.connect(_on_score_changed)

	# Call deferred so that we don't emit before the UI is funnly initialized
	call_deferred("_on_health_changed", health_ref.health, health_ref.health, health_ref.max_health)

	# Register with globals
	AsteroidGameGlobals.player_node = self

## Runs when player heath reaches 0. Plays death particles, waits, and restarts the game
func _on_health_expired(_damage_source_node : Node):
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


## Current implementation is 1:1 score to experience
func _on_score_changed(previous_value : int, new_value : int):
	experience.add_experience(new_value - previous_value)


	
