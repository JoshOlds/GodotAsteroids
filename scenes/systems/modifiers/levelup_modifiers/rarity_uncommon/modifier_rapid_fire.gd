extends ModifierBase
class_name ModifierRapidFire


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.UNCOMMON

	modifier_name = "Rapid Fire"
	description = "15% Increased Fire Rate\n+2 Deg Inaccuracy\n5% Increased Inaccuracy"
	flavor_text = "Don't aim, just SHOOT!"
	
	icon_texture_path = "res://svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.fire_rate_mod.add_increased_mod_value(0.15)
	modifiers.inaccuracy_mod.add_flat_mod_value(2 * PI/180)
	modifiers.inaccuracy_mod.add_increased_mod_value(0.05)

