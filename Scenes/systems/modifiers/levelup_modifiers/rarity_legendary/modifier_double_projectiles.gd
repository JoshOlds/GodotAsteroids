extends ModifierBase
class_name ModifierDoubleProjectiles

func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.LEGENDARY

	modifier_name = "Double Projectiles"
	description = "Doubles Extra Projectiles Amount"
	flavor_text = "Overwhelming Firepower!"
	
	icon_texture_path = "res://svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	if modifiers.multiple_projectiles_mod > 0:
		modifiers.multiple_projectiles_mod = modifiers.multiple_projectiles_mod * 2
	else:
		modifiers.multiple_projectiles_mod += 1
