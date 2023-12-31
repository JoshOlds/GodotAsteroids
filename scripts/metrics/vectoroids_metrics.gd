class_name VectoroidsMetrics
extends Node

## The score value of a proc_asteroid on death
@export var proc_asteroid_score_value : int = 1

## The current score of the player
var score : int = 0

## The elapsed time (milliseconds) of the current game session
var session_time_ms : float = 0

## The elapsed time (seconds) of the current game session
var session_time_seconds : int = 0

## How many proc_asteroids have been spawned
var asteroid_proc_spawned_count : int = 0

## How many proc_asteroids have been killed by the player
var asteroid_proc_killed_count : int = 0

## Timer to update session time
var _session_timer : Timer

var _session_start_time_ms : float = 0

func _ready():
	SignalBroker.asteroid_proc_spawned.connect(_on_asteroid_proc_spawned)
	SignalBroker.asteroid_proc_killed.connect(_on_asteroid_proc_killed)

	# Setup session timer
	_session_start_time_ms = Time.get_ticks_msec()
	_session_timer = Timer.new()
	add_child(_session_timer)
	_session_timer.wait_time = 1
	_session_timer.timeout.connect(_on_session_timer)
	_session_timer.start()


func update_score():
	var prev_score = score
	score = asteroid_proc_killed_count * proc_asteroid_score_value
	SignalBroker.score_changed.emit(prev_score, score)


func _on_asteroid_proc_spawned():
	asteroid_proc_spawned_count += 1


func _on_asteroid_proc_killed():
	asteroid_proc_killed_count += 1
	update_score()


func _on_session_timer():
	session_time_ms = Time.get_ticks_msec() - _session_start_time_ms
	session_time_seconds = int(session_time_ms / 1000)
