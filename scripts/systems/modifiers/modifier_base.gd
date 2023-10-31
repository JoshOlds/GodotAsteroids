extends RefCounted
class_name ModifierBase
## Class that serves as the base of all more complex compound modifiers in the game.

var rarity : Rarity 

var modifier_name : String

var description : String

var flavor_text : String
 
var icon_texture : CompressedTexture2D

var icon_texture_path : String


## Applies modifiers of this compound class to a Modifier type
func apply_modifier(_modifiers : Modifiers):
	pass
