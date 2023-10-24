extends ModifierBase
class_name ModifierShieldedCasing


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.RARE

	modifier_name = "Shielded Casing"
	description = "20% Increased Projectile Lifespan\n10% Reduced Inaccuracy"
	flavor_text = "Full Metal Jacket"
	
	icon_texture_path = "res://svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.lifespan_mod.add_increased_mod_value(0.2)
	modifiers.inaccuracy_mod.subtract_increased_mod_value(0.1)

