extends Node
class_name Modifiers
## Collection of all potential modifiers. 
## Multiple instances of this class may be used for things such as tracking modifiers for multiple players seperately, or modifiers for enemies, etc.


## Emitted any time a modifier value changes. (either on set or when internal modifier value changes)
signal modifiers_changed

# -------------- Projectile Modifiers --------------

## Multiplier for mass of a projectile
var mass_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		mass_mod = new_value
		modifiers_changed.emit()

## Multiplier for damage of a projectile
var damage_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		damage_mod = new_value
		modifiers_changed.emit()

## Multiplier for critical damage chance of the projectile
var crit_chance_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		crit_chance_mod = new_value
		modifiers_changed.emit()

## Multiplier for critical damage of the projectile
var crit_damage_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		crit_damage_mod = new_value
		modifiers_changed.emit()

## Multiplier for size of a projectile
var size_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		size_mod = new_value
		modifiers_changed.emit()

## Multiplier for area of effect of the projectile
var area_of_effect_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		area_of_effect_mod = new_value
		modifiers_changed.emit()

## Multiplier for lifespan of the projectile
var lifespan_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		lifespan_mod = new_value
		modifiers_changed.emit()
		
## Pierce percentage modifier.
## Each time a projectile hits an enemy, its pierce value will be reduced by 100%. 
## If there is any remaining positive pierce value, the projectile will pierce the enemy and have its damage reduced to the remaining pierce percentage.
## If pierce value is over 100% after reduction, the piercing projectile will do full damage on next hit.
var pierce_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		pierce_mod = new_value
		modifiers_changed.emit()
		
## Forking projectiles split upon being destroyed on a target collision. This only applies after all pierce is finished.
## A fork value of 1 causes two projectiles to spawn upon projectile hit. A fork val of 2 causes three projectiles, and so on.
var fork_mod : int = 0:
	set(new_value):
		fork_mod = new_value
		modifiers_changed.emit()
		
## Chaining projectiles 'bounce' off of an enemy and move towards the nearest enemy. This only applies after all pierce and fork is finished.
## Mechanically, a new projectile is spawned that moves towards the closest target with the same speed as the original projectile.
var chain_mod : int = 0:
	set(new_value):
		chain_mod = new_value
		modifiers_changed.emit()


## -------------- Gun Modifiers -----------------

## Multiplier for fire rate of a gun
var fire_rate_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		fire_rate_mod = new_value
		modifiers_changed.emit()

## Multiplier for multiple projectiles fired from a gun
var multiple_projectiles_mod : int = 0:
	set(new_value):
		multiple_projectiles_mod = new_value
		modifiers_changed.emit()

## Multiplier for the spread of projectiles fired from a gun
var spread_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		spread_mod = new_value
		modifiers_changed.emit()

## Multiplier for the impulse strength of projectiles fired from a gun
var spawn_impulse_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		spawn_impulse_mod = new_value
		modifiers_changed.emit()

## Multiplier for the recoil strength of projectiles fired from a gun
var recoil_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		recoil_mod = new_value
		modifiers_changed.emit()

## Multiplier for inaccuracy (angle error when firing) of projectiles fired from a gun
var inaccuracy_mod : ModifierValue = ModifierValue.new():
	set(new_value):
		inaccuracy_mod = new_value
		modifiers_changed.emit()

# ---------------------------------------------------------------------

func _init():
	# Hook up all signals from modifiers to this objects signal output
	mass_mod.modifier_changed.connect(_on_modifier_change)
	damage_mod.modifier_changed.connect(_on_modifier_change)
	crit_chance_mod.modifier_changed.connect(_on_modifier_change)
	crit_damage_mod.modifier_changed.connect(_on_modifier_change)
	size_mod.modifier_changed.connect(_on_modifier_change)
	area_of_effect_mod.modifier_changed.connect(_on_modifier_change)
	lifespan_mod.modifier_changed.connect(_on_modifier_change)
	fire_rate_mod.modifier_changed.connect(_on_modifier_change)
	spread_mod.modifier_changed.connect(_on_modifier_change)
	spawn_impulse_mod.modifier_changed.connect(_on_modifier_change)
	recoil_mod.modifier_changed.connect(_on_modifier_change)
	inaccuracy_mod.modifier_changed.connect(_on_modifier_change)


func _on_modifier_change():
	modifiers_changed.emit()


