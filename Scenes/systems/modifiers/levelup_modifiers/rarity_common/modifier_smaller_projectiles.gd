extends ModifierBase
class_name ModifierSmallerProjectiles


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.COMMON

	modifier_name = "Smaller Projectiles"
	description = "10% Reduced Projectile Size\n10% Reduced Projectile Mass\n10% Increased Projectile Impulse\n5% Increased Damage"
	flavor_text = "Smaller, Faster, Stronger"
	
	icon_texture_path = "res://svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.size_mod.subtract_increased_mod_value(0.1)
	modifiers.mass_mod.subtract_increased_mod_value(0.1)
	modifiers.spawn_impulse_mod.add_increased_mod_value(0.1)
	modifiers.damage_mod.add_increased_mod_value(0.05)

