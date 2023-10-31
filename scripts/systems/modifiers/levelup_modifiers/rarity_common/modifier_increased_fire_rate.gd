extends ModifierBase
class_name ModifierIncreasedFireRate


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.COMMON

	modifier_name = "Increased Fire Rate"
	description = "5% Increased Fire Rate"
	flavor_text = "A little bit faster"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.fire_rate_mod.add_increased_mod_value(0.05)

