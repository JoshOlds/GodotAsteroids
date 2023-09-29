class_name HealthBase
extends Node

signal health_expired

@export var health : float

@export var max_health : float

@export var health_can_be_negative : bool


func _on_damage_received(damage_value : float):
	receive_damage(damage_value)
	

func set_health(health_value : float):
	health = health_value
	_check_health()
	

func receive_damage(damage_value : float):
	health -= damage_value
	_check_health()
		
		
func add_health(health_value : float):
	health += health_value
	_check_health()
			
			
func _check_health():
	if health <= 0:
		if health_can_be_negative == false:
			health = 0
		health_expired.emit()
	elif max_health > 0:
		if health > max_health:
			health = max_health
		
		
