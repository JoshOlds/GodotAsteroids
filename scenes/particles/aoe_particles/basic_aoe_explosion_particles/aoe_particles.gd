extends GPUParticles2DOneshotFree
class_name AoeParticles

## Class that dynamically scales child particle effect to match the AoE radius provided
## Used to adjust particle effects to accurately represent AoE radius to players

## AoE Radius used to scale the size/velocity of the child AoE particles. 
var aoe_radius : float = 1


func _ready():
	super._ready()
	var aoe_velocity = aoe_radius / lifetime
	var mat = process_material.duplicate() as ParticleProcessMaterial
	mat.initial_velocity_min = aoe_velocity
	mat.initial_velocity_max = aoe_velocity
	process_material = mat

