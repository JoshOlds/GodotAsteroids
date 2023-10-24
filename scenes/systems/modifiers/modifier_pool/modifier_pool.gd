extends Node
class_name ModifierPool
## Pool of potential modifiers. Has functions for rolling rarity for and selecting unique modifiers.

## Simple type for associating a Modifier with its rolled rarity value
class RolledRarity:
	var rarity_enum : Rarity.RarityEnum
	var roll : float


## Pool of available modifiers
var common_pool : Array[ModifierBase] = []
var uncommon_pool : Array[ModifierBase] = []
var rare_pool : Array[ModifierBase] = []
var epic_pool : Array[ModifierBase] = []
var legendary_pool : Array[ModifierBase] = []


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED

	
## Rolls rarity for all modifiers in modifier_pool. Will return an array of modifier_amount size that contains the modifiers that rolled highest
func roll_for_modifiers(modifier_amount : int) -> Array[ModifierBase]:
	var return_modifiers : Array[ModifierBase] = []
	
	# Create copies of each pool so we can remove chosen modifiers from them
	var temp_common_pool = common_pool.duplicate()
	var temp_uncommon_pool = uncommon_pool.duplicate()
	var temp_rare_pool = rare_pool.duplicate()
	var temp_epic_pool = epic_pool.duplicate()
	var temp_legendary_pool = legendary_pool.duplicate()
	
	for i in range(0, modifier_amount):
		# Get rolls for each rarity
		var common_rr = _new_rolled_rarity(Rarity.RarityEnum.COMMON)
		var uncommon_rr = _new_rolled_rarity(Rarity.RarityEnum.UNCOMMON)
		var rare_rr = _new_rolled_rarity(Rarity.RarityEnum.RARE)
		var epic_rr = _new_rolled_rarity(Rarity.RarityEnum.EPIC)
		var legendary_rr = _new_rolled_rarity(Rarity.RarityEnum.LEGENDARY)
		
		print("Common: " + str(common_rr.roll))
		print("Uncommon: " + str(uncommon_rr.roll))
		print("Rare: " + str(rare_rr.roll))
		print("Epic: " + str(epic_rr.roll))
		print("Legendary: " + str(legendary_rr.roll))
		
		# Use the pool from the highest rarity rolled
		var rarity_pool = temp_common_pool
		var highest_rr = common_rr
		if uncommon_rr.roll > highest_rr.roll and temp_uncommon_pool.size() > 0:
			highest_rr = uncommon_rr
			rarity_pool = temp_uncommon_pool
		if rare_rr.roll > highest_rr.roll and temp_rare_pool.size() > 0:
			highest_rr = rare_rr
			rarity_pool = temp_rare_pool
		if epic_rr.roll > highest_rr.roll and temp_epic_pool.size() > 0:
			highest_rr = epic_rr
			rarity_pool = temp_epic_pool
		if legendary_rr.roll > highest_rr.roll and temp_legendary_pool.size() > 0:
			highest_rr = legendary_rr
			rarity_pool = temp_legendary_pool
		
		# Select random modifier from chosen rarity pool
		var random_index : int = randi_range(0, rarity_pool.size() - 1)
		return_modifiers.append(rarity_pool[random_index])
		rarity_pool.remove_at(random_index)
	return return_modifiers

	
## Constructs and returns a new RolledRarity for a given RarityEnum
func _new_rolled_rarity(rarity_enum : Rarity.RarityEnum) -> RolledRarity:
	var rolled_rarity = RolledRarity.new()
	rolled_rarity.rarity_enum = rarity_enum
	rolled_rarity.roll = Rarity.roll_rarity(rarity_enum)
	return rolled_rarity
