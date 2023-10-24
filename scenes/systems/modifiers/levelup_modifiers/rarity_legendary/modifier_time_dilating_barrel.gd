extends ModifierBase
class_name ModifierTimeDilatingBarrel


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.LEGENDARY

	modifier_name = "Time Dilating Barrel"
	description = "25% More Fire Rate"
	flavor_text = "Quark coated barrel stretches time itself"
	
	icon_texture_path = "res://svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.fire_rate_mod.add_more_mod_value(0.25)
