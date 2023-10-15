extends Node
class_name ModifierPool
## Pool of potential modifiers. Has functions for rolling rarity for and selecting unique modifiers.

## Pool of available modifiers
var modifier_pool : Array[ModifierBase] = []


## Simple type for associating a Modifier with its rolled rarity value
class RolledModifier:
	var mod : ModifierBase
	var roll : float


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED

	
## Rolls rarity for all modifiers in modifier_pool. Will return an array of modifier_amount size that contains the modifiers that rolled highest
func roll_for_modifiers(modifier_amount : int) -> Array[ModifierBase]:
	var return_array : Array[ModifierBase] = []
	var rolled_array : Array[RolledModifier] = []
	for pool_mod : ModifierBase in modifier_pool:
		# Create a RolledModifier to store modifier and rarity roll together
		var rmod : RolledModifier = RolledModifier.new()
		rmod.mod = pool_mod
		rmod.roll = pool_mod.rarity.roll_rarity()
		# If our return_array is not yet full, add without checking existing rolls
		if rolled_array.size() < modifier_amount:
			rolled_array.push_back(rmod)	
		else:
			# Iterate through the existing rolled array. 
			for i in range(rolled_array.size()):
				# If rmod.roll value is greater than an existing roll, insert and delete the last element the gets pushed out
				if rolled_array[i].roll < rmod.roll:
					rolled_array.insert(i, rmod)
					rolled_array.pop_back() # delete last element
		# Sort by roll so that we know the last element is always the smallest roll (thus popping back works to remove smallest roll)
		rolled_array.sort_custom(_sort_rolled_modifiers)
	# Fill out the array to return
	for rmod : RolledModifier in rolled_array:
		return_array.append(rmod.mod)	
	return return_array


## Custom sort function used to sort modifiers 
func _sort_rolled_modifiers(a : RolledModifier, b : RolledModifier) -> bool:
	if a.roll < b.roll:
		return false
	return true
