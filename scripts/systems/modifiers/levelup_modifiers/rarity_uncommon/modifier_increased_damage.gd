extends ModifierBase
class_name ModifierIncreasedDamage


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.UNCOMMON

	modifier_name = "Increased Damage"
	description = "15% Increased Damage"
	flavor_text = "The best defense is a good offense"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.damage_mod.add_increased_mod_value(0.15)

