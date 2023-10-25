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
	var muzzle_brake : ModifierBase = ModifierMuzzleBrake.new()
	modifier_pool.common_pool.append(muzzle_brake)
	var smaller_projectiles : ModifierBase = ModifierSmallerProjectiles.new()
	modifier_pool.common_pool.append(smaller_projectiles)
	
	
	# Uncommon -----------------------------------------------------------------------------
	var high_caliber : ModifierBase = ModifierHighCaliber.new()
	modifier_pool.uncommon_pool.append(high_caliber)
	var hone_in : ModifierBase = ModifierHoneIn.new()
	modifier_pool.uncommon_pool.append(hone_in)
	var increased_damage : ModifierBase = ModifierIncreasedDamage.new()
	modifier_pool.uncommon_pool.append(increased_damage)
	var overpressure : ModifierBase = ModifierOverpressure.new()
	modifier_pool.uncommon_pool.append(overpressure)
	var rapid_fire : ModifierBase = ModifierRapidFire.new()
	modifier_pool.uncommon_pool.append(rapid_fire)
	
	# Rare -----------------------------------------------------------------------------
	var heartseeker : ModifierBase = ModifierHeartseeker.new()
	modifier_pool.rare_pool.append(heartseeker)
	var muzzle_choke : ModifierBase = ModifierMuzzleChoke.new()
	modifier_pool.rare_pool.append(muzzle_choke)
	
	# Epic -----------------------------------------------------------------------------
	var explosive_payload : ModifierBase = ModifierExplosivePayload.new()
	modifier_pool.epic_pool.append(explosive_payload)
	var extended_barrel : ModifierBase = ModifierExtendedBarrel.new()
	modifier_pool.epic_pool.append(extended_barrel)
	var extra_projectile : ModifierBase = ModifierExtraProjectile.new()
	modifier_pool.epic_pool.append(extra_projectile)
	var sniper_specialization : ModifierBase = ModifierSniperSpecialization.new()
	modifier_pool.epic_pool.append(sniper_specialization)
	
	# Legendary -----------------------------------------------------------------------------
	var double_projectiles : ModifierBase = ModifierDoubleProjectiles.new()
	modifier_pool.legendary_pool.append(double_projectiles)
	var time_dilating_barrel : ModifierBase = ModifierTimeDilatingBarrel.new()
	modifier_pool.legendary_pool.append(time_dilating_barrel)
