class_name AsteroidGameMetrics
extends Node

## The score value of a proc_asteroid on death
@export var proc_asteroid_score_value : int = 1

## The current score of the player
var score : int = 0

## How many proc_asteroids have been spawned
var asteroid_proc_spawned_count : int = 0

## How many proc_asteroids have been killed by the player
var asteroid_proc_killed_count : int = 0


func _ready():
	SignalBroker.asteroid_proc_spawned.connect(_on_asteroid_proc_spawned)
	SignalBroker.asteroid_proc_killed.connect(_on_asteroid_proc_killed)

func update_score():
	var prev_score = score
	score = asteroid_proc_killed_count * proc_asteroid_score_value
	SignalBroker.score_changed.emit(prev_score, score)

func _on_asteroid_proc_spawned():
	asteroid_proc_spawned_count += 1

func _on_asteroid_proc_killed():
	asteroid_proc_killed_count += 1
	update_score()
