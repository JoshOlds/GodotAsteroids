class_name CooldownTimer
extends Timer

## The time (in seconds) to wait before cooldown resets
@export var cooldown_time : float

## Flag specifying if on cooldown
var _on_cooldown : bool = false


func _ready():
	wait_time = cooldown_time
	one_shot = true
	timeout.connect(reset_cooldown)


func start_cooldown():
	_on_cooldown = true
	wait_time = cooldown_time
	start()


func reset_cooldown():
	_on_cooldown = false


func is_on_cooldown() -> bool:
	return _on_cooldown
