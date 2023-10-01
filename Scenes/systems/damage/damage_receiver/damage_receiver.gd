class_name DamageReceiver
extends Node
## Part of the damage system. Node that is capable of receiving damage from a DamageApplyer. Broadcasts a signal when damage received

signal damage_received(damage_value : float)

## Damage will not be received from  any object with 'Group' tag that matches a string in this blacklist
@export var group_blacklist : Array[String] = []

## Damage will ONLY be received from an object with 'Group' tag that matches a string in thie whitelist
@export var group_whitelist : Array[String] = []


func receive_damage(damage_source_node : Node, damage_value : float):
	# Do not receive damage if source node's group is in blacklist
	if is_node_in_blacklist(damage_source_node):
		return
	# Only check whitelist if not empty
	if not group_whitelist.is_empty():
		# Do not receive damage if source node's group is NOT in whitelist
		if not is_node_in_whitelist(damage_source_node):
			return
	damage_received.emit(damage_value)


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
