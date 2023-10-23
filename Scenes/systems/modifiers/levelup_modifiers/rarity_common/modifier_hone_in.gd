extends ModifierBase
class_name ModifierHoneIn


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.COMMON

	modifier_name = "Hone In"
	description = "-1 Degree Inaccuracy"
	flavor_text = "Breathe, Aim, ..."
	
	icon_texture_path = "res://svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.inaccuracy_mod.subtract_flat_mod_value(PI/180)

