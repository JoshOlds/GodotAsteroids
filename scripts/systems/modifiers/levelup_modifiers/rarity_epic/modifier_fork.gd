extends ModifierBase
class_name ModifierFork


func _init():
	rarity = Rarity.new()
	rarity.rarity = rarity.RarityEnum.EPIC

	modifier_name = "Fork"
	description = "+1 Projectile Fork"
	flavor_text = "Split, Multiply"
	
	icon_texture_path = "res://images/svg/ArrowOpenBack.svg"
	icon_texture = load(icon_texture_path)

func apply_modifier(modifiers : Modifiers):
	modifiers.fork_mod += 1


