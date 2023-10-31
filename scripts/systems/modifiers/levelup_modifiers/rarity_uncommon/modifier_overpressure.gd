extends ModifierBase
class_name ModifierOverpressure


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.UNCOMMON

	modifier_name = "Overpressure"
	description = "20% Increased Impulse\n10% Increased Recoil\n5% Increased Damage"
	flavor_text = "A bit more powder should do the trick"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.spawn_impulse_mod.add_increased_mod_value(0.20)
	modifiers.recoil_mod.add_increased_mod_value(0.10)
	modifiers.damage_mod.add_increased_mod_value(0.05)

