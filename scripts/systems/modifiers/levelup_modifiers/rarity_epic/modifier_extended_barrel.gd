extends ModifierBase
class_name ModifierExtendedBarrel


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.EPIC

	modifier_name = "Extended Barrel"
	description = "25% Increased Impuse\n10% Reduced Recoil\n10% Reduced Inaccuracy"
	flavor_text = "Bolt action beauty"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.spawn_impulse_mod.add_increased_mod_value(0.25)
	modifiers.recoil_mod.subtract_increased_mod_value(0.1)
	modifiers.inaccuracy_mod.subtract_increased_mod_value(0.1)

