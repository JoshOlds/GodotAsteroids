class_name DamageReceiver
extends Node
## Part of the damage system. Node that is capable of receiving damage from a DamageApplyer. Broadcasts a signal when damage received

signal damage_received(damage_value : float)

func receive_damage(damage_value : float):
	damage_received.emit(damage_value)
