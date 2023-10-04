class_name PlayerExperience
extends Node
## Class for managing player level and experience points

## The player's current level
@export var player_level : int = 1

## The player's current experience points towards the next level
@export var player_experience : int = 0

## The Player's total experience earned (regardless of level)
var player_total_experience : int = 0

## The experience required to next level up
var experience_to_next_level : int


func _init():
	experience_to_next_level = _get_experience_to_next_level(player_level)


func add_experience(value : int):
	if(value < 0):
		push_warning("PlayerExperience: Tried to add negative experience.")
		return
	var prev_exp = player_experience
	player_experience += value
	player_total_experience += value
	check_levelup()
	SignalBroker.player_experience_changed.emit(prev_exp, player_experience, experience_to_next_level)


func check_levelup() -> bool:
	if player_experience >= experience_to_next_level:
		_player_level_up()
		return true
	return false
		

func _player_level_up():
	var prev_level = player_level
	player_experience -= experience_to_next_level
	player_level += 1
	experience_to_next_level = _get_experience_to_next_level(player_level)
	SignalBroker.player_level_up.emit(prev_level, player_level)


func _get_experience_to_next_level(current_level : int) -> int:
	var experience_needed : int = 0
	experience_needed = 10 * current_level
	return experience_needed
