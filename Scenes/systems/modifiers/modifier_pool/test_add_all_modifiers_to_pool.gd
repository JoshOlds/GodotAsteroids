extends Node

@export var modifier_pool : ModifierPool

func _ready():
	var bigger_projectiles : ModifierBase = ModifierBiggerProjectiles.new()
	modifier_pool.modifier_pool.append(bigger_projectiles)
	var smaller_projectiles : ModifierBase = ModifierSmallerProjectiles.new()
	modifier_pool.modifier_pool.append(smaller_projectiles)
	var extra_projectile : ModifierBase = ModifiersExtraProjectile.new()
	modifier_pool.modifier_pool.append(extra_projectile)
