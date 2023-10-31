extends ModifierBase
class_name ModifierHeartseeker


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.RARE

	modifier_name = "Heartseeker"
	description = "Adds 6% Crit Chance\nAdds 15% Crit Damage"
	flavor_text = "In a single strike"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.crit_chance_mod.add_flat_mod_value(0.06)
	modifiers.crit_damage_mod.add_flat_mod_value(0.15)

