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

