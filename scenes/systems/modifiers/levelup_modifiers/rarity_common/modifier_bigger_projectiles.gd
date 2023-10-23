extends ModifierBase
class_name ModifierBiggerProjectiles

func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.COMMON

	modifier_name = "Bigger Projectiles"
	description = "10% Increased Projectile Size\n10% Increased Projectile Mass\n5% Increased Damage\n5% Reduced Projectile Impulse"
	flavor_text = "Bigger is always better"
	
	icon_texture_path = "res://svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.mass_mod.add_increased_mod_value(0.1)
	modifiers.size_mod.add_increased_mod_value(0.1)
	modifiers.spawn_impulse_mod.subtract_increased_mod_value(0.05)
	modifiers.damage_mod.add_increased_mod_value(0.05)
	
