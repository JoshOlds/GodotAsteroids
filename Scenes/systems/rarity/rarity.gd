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


func roll_rarity() -> float:
	if rarity == RarityEnum.COMMON:
		return randf() * 1000
	if rarity == RarityEnum.UNCOMMON:
		return randf() * 500
	if rarity == RarityEnum.RARE:
		return randf() * 200
	if rarity == RarityEnum.EPIC:
		return randf() * 100
	if rarity == RarityEnum.LEGENDARY:
		return randf() * 25
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

