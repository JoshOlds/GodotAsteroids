extends ModifierBase
class_name ModifierIncreasedCritChance


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.COMMON

	modifier_name = "Critical Chance"
	description = "Adds 3% Critical Chance"
	flavor_text = "Lucky shot"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svgack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.crit_chance_mod.add_flat_mod_value(0.03)

