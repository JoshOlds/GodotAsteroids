extends ModifierBase
class_name ModifierMuzzleChoke


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.RARE

	modifier_name = "Muzzle Choke"
	description = "20% Less Spread"
	flavor_text = "Concentrate Fire!"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.spread_mod.subtract_more_mod_value(0.20)

