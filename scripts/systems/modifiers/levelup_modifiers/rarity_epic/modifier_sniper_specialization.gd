extends ModifierBase
class_name ModifierSniperSpecialization


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.EPIC

	modifier_name = "Sniper Specialization"
	description = "5x Damage\n2x Impulse\n3x AoE\n1/3 Fire Rate"
	flavor_text = "BFG"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.damage_mod.add_more_mod_value(4.0)
	modifiers.spawn_impulse_mod.add_more_mod_value(1.0)
	modifiers.area_of_effect_mod.add_more_mod_value(2.0)
	modifiers.fire_rate_mod.subtract_more_mod_value(2.0)
