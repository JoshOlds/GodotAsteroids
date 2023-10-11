class_name WeaponModifiers
extends Node

const WeaponModifier = preload("res://Scenes/systems/weapon_modifiers/weapon_modifier.gd")


## Emitted any time a modifier value changes
signal weapon_modifiers_changed

# -------------- Projectile Modifiers --------------

## Multiplier for mass of a projectile
var mass_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		mass_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for damage of a projectile
var damage_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		damage_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for critical damage chance of the projectile
var crit_chance_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		crit_chance_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for critical damage of the projectile
var crit_damage_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		crit_damage_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for size of a projectile
var size_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		size_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for area of effect of the projectile
var area_of_effect_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		area_of_effect_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for lifespan of the projectile
var lifespan_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		lifespan_mod = new_value
		weapon_modifiers_changed.emit()


## -------------- Gun Modifiers -----------------

## Multiplier for fire rate of a gun
var fire_rate_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		fire_rate_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for multiple projectiles fired from a gun
var multiple_projectiles_mod : int = 0:
	set(new_value):
		multiple_projectiles_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for the spread of projectiles fired from a gun
var spread_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		spread_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for the impulse strength of projectiles fired from a gun
var spawn_impulse_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		spawn_impulse_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for the recoil strength of projectiles fired from a gun
var recoil_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		recoil_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for inaccuracy (angle error when firing) of projectiles fired from a gun
var inaccuracy_mod : WeaponModifier = WeaponModifier.new():
	set(new_value):
		inaccuracy_mod = new_value
		weapon_modifiers_changed.emit()


