extends ModifierBase
class_name ModifierHighCaliber


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.UNCOMMON

	modifier_name = "High Caliber"
	description = "20% Increased Damage\n20% Less Fire Rate"
	flavor_text = "You're a sniper, Larry"
	
	icon_texture_path = "res://svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.damage_mod.add_increased_mod_value(0.2)
	modifiers.fire_rate_mod.subtract_more_mod_value(0.2)

