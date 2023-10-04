class_name HealthBase
extends Node
## Base node for the Health system. Broadcasts a signal when health expires.

## Signal broadcast when health reaches 0
signal health_expired

## signal broadcast whenever health changes value
signal health_changed(previous_value : float, new_value : float, max_health : float)

## Health of this node
@export var health : float

## Max health of this node. Cannot gain health above this value
@export var max_health : float

## Flag specifying whether health can be negative
@export var health_can_be_negative : bool

## Flag specifying whether health has expired (reached 0)
var _has_expired : bool = false


## Callback when damage is received. Intended to be connected to a DamageReceiver's signal
func _on_damage_received(damage_value : float):
	receive_damage(damage_value)
	

## Sets the health of this node to a value
func set_health(health_value : float):
	var prev_health = health
	health = health_value
	_check_health()
	health_changed.emit(prev_health, health, max_health)
	

## Apply damage to this health node
func receive_damage(damage_value : float):
	var prev_health = health
	health -= damage_value
	_check_health()
	health_changed.emit(prev_health, health, max_health)
	

## Add health to the existing health of this node
func add_health(health_value : float):
	var prev_health = health
	health += health_value
	_check_health()
	health_changed.emit(prev_health, health, max_health)
			
			
## Clamps health within bounds and emits signal if health has expired
func _check_health():
	if health <= 0:
		if not health_can_be_negative:
			health = 0
		## Only emit health expired if this is the first time health reached zero
		if not _has_expired:
			health_expired.emit()
			_has_expired = true
	# Clamp to max health
	elif max_health > 0:
		if health > max_health:
			health = max_health
	# Reset _has_expired if health was added
	if health > 0:
		_has_expired = false
	
		
		
