class_name DamageApplyer
extends Node
## Part of the Damage System. Node that handles applying damage to any other node that has a DamageReceiver component

## This node will be passed to the DamageReceiver when applying damage. Useful for informing receiver of who applied damage
@export var parent : Node

## Damage will not be applied to any object with 'Group' tag that matches a string in the blacklist
@export var group_blacklist : Array[String] = []

## Damage will ONLY be applied to an object with 'Group' tag that matches a string in the whitelist. Empty whitelist will be ignored (no group will be filtered)
@export var group_whitelist : Array[String] = []

func apply_damage_to_node(node : Node, damage_value : float):
	var receiver = node.get_node("DamageReceiver") as DamageReceiver
	if receiver != null:
		# Do not apply damage if target node's group is in blacklist
		if is_node_in_blacklist(node):
			return
		# Only check whitelist if not empty
		if not group_whitelist.is_empty():
			# Do not apply damage if target node's group is NOT in whitelist
			if not is_node_in_whitelist(node):
				return
		apply_damage_to_receiver(receiver, damage_value)

	
func apply_damage_to_receiver(receiver : DamageReceiver, damage_value : float):
	receiver.receive_damage(parent, damage_value)
	print("Damage: " + str(damage_value))


func is_node_in_blacklist(node : Node) -> bool:
		if not group_blacklist.is_empty():
			for group_name in group_blacklist:
				if node.is_in_group(group_name):
					return true
		return false
			

func is_node_in_whitelist(node : Node) -> bool:
		if not group_whitelist.is_empty():
			for group_name in group_whitelist:
				if node.is_in_group(group_name):
					return true
		return false		
