class_name DamageReceiver
extends Node

signal damage_received(damage_value : float)

func receive_damage(damage_value : float):
	damage_received.emit(damage_value)
