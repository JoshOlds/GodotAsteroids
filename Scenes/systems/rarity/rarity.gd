extends RefCounted
class_name Rarity
## Type that represents Rarity. 

enum RarityEnum{
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}

## The rarity of this Rarity type. Defaults to RarityEnum.COMMON
var rarity : RarityEnum = RarityEnum.COMMON


## Rolls for rarity on self
func roll_rarity_self() -> float:
	return roll_rarity(rarity)
	

## Static function to roll dice value for a given rarity
static func roll_rarity(rarity_enum : RarityEnum) -> float:
	if rarity_enum == RarityEnum.COMMON:
		return randf() * 1000
	if rarity_enum == RarityEnum.UNCOMMON:
		return randf() * 1000
		#return randf() * 800
	if rarity_enum == RarityEnum.RARE:
		return randf() * 1000
		#return randf() * 500
	if rarity_enum == RarityEnum.EPIC:
		return randf() * 1000
		#return randf() * 300
	if rarity_enum == RarityEnum.LEGENDARY:
		return randf() * 1000
		#return randf() * 100
	return 0
	

## Returns a color value for a given RarityEnum
static func get_rarity_color(rarity_enum : RarityEnum) -> Color:
	if rarity_enum == RarityEnum.COMMON:
		return Color.GRAY
	if rarity_enum == RarityEnum.UNCOMMON:
		return Color.DARK_GREEN
	if rarity_enum == RarityEnum.RARE:
		return Color.NAVY_BLUE
	if rarity_enum == RarityEnum.EPIC:
		return Color.REBECCA_PURPLE
	if rarity_enum == RarityEnum.LEGENDARY:
		return Color.DARK_ORANGE
	return Color.GRAY

