class_name WeaponModifiers
extends Node

## Emitted any time a modifier value changes
signal weapon_modifiers_changed


## Multiplier for mass of a projectile
var mass_mod : float = 1.0 :
	set(new_value):
		mass_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for damage of a projectile
var damage_mod : float = 1.0 :
	set(new_value):
		damage_mod = new_value
		weapon_modifiers_changed.emit()


## Multiplier for size of a projectile
var size_mod : float = 1.0 :
	set(new_value):
		size_mod = new_value
		weapon_modifiers_changed.emit()


## -------------- Gun Modifiers -----------------

## Multiplier for fire rate of a gun
var fire_rate_mod : float = 1.0 :
	set(new_value):
		fire_rate_mod = new_value
		weapon_modifiers_changed.emit()

## Multiplier for multiple projectiles fired from a gun
var multiple_projectiles_mod : int = 1 :
	set(new_value):
		multiple_projectiles_mod = new_value
		weapon_modifiers_changed.emit()


## Multiplier for the spread of projectiles fired from a gun
var spread_mod : float = 1.0 :
	set(new_value):
		spread_mod = new_value
		weapon_modifiers_changed.emit()


