class_name DamageApplyer
extends Node
## Part of the Damage System. Node that handles applying damage to any other node that has a DamageReceiver component

## This node will be passed to the DamageReceiver when applying damage. Useful for informing receiver of who applied damage
@export var parent : Node

## Damage will not be applied to any object with 'Group' tag that matches a string in the blacklist
@export var group_blacklist : Array[String] = []

## Damage will ONLY be applied to an object with 'Group' tag that matches a string in the whitelist. Empty whitelist will be ignored (no group will be filtered)
@export var group_whitelist : Array[String] = []

## Default damage value used if no damage value is provided when calling various damage functions
@export var default_damage : float

## If true, this damage applyer will require a cooldown before applying damage again
@export var uses_cooldown : bool = false

## Time (in seconds) before damage can be applyed again
@export var cooldown_time : float = 1

## Timer used to reset cooldown
var _cooldown_timer : CooldownTimer

func _ready():
	_cooldown_timer = CooldownTimer.new()
	_cooldown_timer.cooldown_time = cooldown_time
	add_child(_cooldown_timer)
	

func apply_damage_to_node(node : Node, damage_value : float = 0):
	# Handle cooldown if enabled
	if uses_cooldown:
		if _cooldown_timer.is_on_cooldown():
			return
		else:
			_cooldown_timer.cooldown_time = cooldown_time
			_cooldown_timer.start_cooldown()
			
	# Use default damage if node supplied		
	if damage_value == 0:
		damage_value = default_damage
	
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
