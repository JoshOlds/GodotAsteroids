extends ModifierBase
class_name ModifiersExtraProjectile


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.EPIC

	modifier_name = "Extra Projectile"
	description = "+1 Extra Projectile"
	flavor_text = "Another!"
	
	icon_texture_path = "res://SVGs/ArrowOpenBack.svg"
	icon_texture = CompressedTexture2D.new()
	icon_texture.load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.multiple_projectiles_mod += 1

