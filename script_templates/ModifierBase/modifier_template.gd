# meta-description: Base template for all Vecteroids Modifiers

extends _BASE_
class_name _CLASS_


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.COMMON

	modifier_name = ""
	description = ""
	flavor_text = ""
	
	icon_texture_path = "res://SVGs/ArrowOpenBack.svg"
	icon_texture = CompressedTexture2D.new()
	icon_texture.load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	#modifiers.mass_mod.add_increased_mod_value(0.1)
	pass
