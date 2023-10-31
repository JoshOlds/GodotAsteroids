extends ModifierBase
class_name ModifierExplosivePayload


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.EPIC

	modifier_name = "Explosive Payload"
	description = "+25 Area of Effect Radius"
	flavor_text = "BOOM!"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.area_of_effect_mod.add_flat_mod_value(25.0)

