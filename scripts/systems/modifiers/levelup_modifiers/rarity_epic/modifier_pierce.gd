extends ModifierBase
class_name ModifierPierce


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.EPIC

	modifier_name = "Pierce"
	description = "+1 Projectile Pierce"
	flavor_text = "Projectiles fully pierce one additional target"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.pierce_mod.add_flat_mod_value(1)

