extends AoeParticleBase

@export var particles : GPUParticles2D


func _ready():
	var lifetime = particles.lifetime
	var aoe_velocity = aoe_radius / lifetime
	var mat = particles.process_material.duplicate() as ParticleProcessMaterial
	mat.initial_velocity_min = aoe_velocity
	mat.initial_velocity_max = aoe_velocity
	particles.process_material = mat

