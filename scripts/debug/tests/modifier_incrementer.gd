extends Node

## Time, in seconds, between when increments will be added
@export var increment_time_seconds : float

@export var modifiers_ref : Modifiers

@export var mass_increment : float = 0
@export var damage_increment : float = 0
@export var crit_chance_increment : float = 0
@export var crit_damage_increment : float = 0
@export var size_increment : float = 0
@export var aoe_increment : float = 0
@export var lifespan_increment : float = 0


var increment_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():

	# Setup and start timer
	increment_timer = Timer.new()
	add_child(increment_timer)
	increment_timer.wait_time = increment_time_seconds
	increment_timer.timeout.connect(_on_increment_timer_timeout)
	increment_timer.start()


func _on_increment_timer_timeout():
	modifiers_ref.mass_mod.add_flat_mod_value(mass_increment)
	modifiers_ref.damage_mod.add_flat_mod_value(damage_increment)
	modifiers_ref.crit_chance_mod.add_flat_mod_value(crit_chance_increment)
	modifiers_ref.crit_damage_mod.add_flat_mod_value(crit_damage_increment)
	modifiers_ref.size_mod.add_flat_mod_value(size_increment)
	modifiers_ref.area_of_effect_mod.add_flat_mod_value(aoe_increment)
	modifiers_ref.lifespan_mod.add_flat_mod_value(lifespan_increment)
