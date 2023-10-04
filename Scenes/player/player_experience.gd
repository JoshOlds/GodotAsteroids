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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_experience(value : int):
	player_experience += value
	player_total_experience += value


func check_levelup() -> bool:
	if player_experience >= experience_to_next_level:
		_player_level_up()
		return true
	return false
		

func _player_level_up():
	var prev_level = player_level
	player_experience -= experience_to_next_level
	player_level += 1
	SignalBroker.player_level_up.emit(prev_level, player_level)