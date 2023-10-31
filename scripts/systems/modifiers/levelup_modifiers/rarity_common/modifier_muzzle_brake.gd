extends ModifierBase
class_name ModifierMuzzleBrake


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.COMMON

	modifier_name = "Muzzle Brake"
	description = "5% Reduced Recoil\n5% Increased Impulse"
	flavor_text = "Let's make use of that hot gas"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.recoil_mod.subtract_increased_mod_value(0.05)
	modifiers.spawn_impulse_mod.add_increased_mod_value(0.05)


