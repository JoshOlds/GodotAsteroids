extends Node

@export var modifier_pool : ModifierPool

func _ready():
	# Common -----------------------------------------------------------------------------
	var bigger_projectiles : ModifierBase = ModifierBiggerProjectiles.new()
	modifier_pool.common_pool.append(bigger_projectiles)
	var increased_crit_chance : ModifierBase = ModifierIncreasedCritChance.new()
	modifier_pool.common_pool.append(increased_crit_chance)
	var increased_fire_rate : ModifierBase = ModifierIncreasedFireRate.new()
	modifier_pool.common_pool.append(increased_fire_rate)
	var smaller_projectiles : ModifierBase = ModifierSmallerProjectiles.new()
	modifier_pool.common_pool.append(smaller_projectiles)
	
	
	# Uncommon -----------------------------------------------------------------------------
	var hone_in : ModifierBase = ModifierHoneIn.new()
	modifier_pool.uncommon_pool.append(hone_in)
	var increased_damage : ModifierBase = ModifierIncreasedDamage.new()
	modifier_pool.uncommon_pool.append(increased_damage)
	var overfire : ModifierBase = ModifierOverfire.new()
	modifier_pool.uncommon_pool.append(overfire)
	var overpressure : ModifierBase = ModifierOverpressure.new()
	modifier_pool.uncommon_pool.append(overpressure)
	
	# Rare -----------------------------------------------------------------------------
	var heartseeker : ModifierBase = ModifierHeartseeker.new()
	modifier_pool.rare_pool.append(heartseeker)
	var muzzle_choke : ModifierBase = ModifierMuzzleChoke.new()
	modifier_pool.rare_pool.append(muzzle_choke)
	
	# Epic -----------------------------------------------------------------------------
	var extra_projectile : ModifierBase = ModifiersExtraProjectile.new()
	modifier_pool.epic_pool.append(extra_projectile)
	
	# Legendary -----------------------------------------------------------------------------
	var double_projectiles : ModifierBase = ModifierDoubleProjectiles.new()
	modifier_pool.legendary_pool.append(double_projectiles)
