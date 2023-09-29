class_name DamageApplyer
extends Node


func apply_damage_to_node(node : Node, damage_value : float):
	var receiver = node.get_node("DamageReceiver") as DamageReceiver
	if receiver != null:
		apply_damage_to_receiver(receiver, damage_value)

	
func apply_damage_to_receiver(receiver : DamageReceiver, damage_value : float):
	receiver.receive_damage(damage_value)
