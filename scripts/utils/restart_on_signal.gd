extends Node

## Wait time (seconds) after receiving signal before restarting scene
@export var scene_change_delay : float = 1.0

## Flag to specify whether to connect to a global SignalBroker signal
@export var use_global_signal_broker_signal : bool = false

## The global SignalBroker signal to connect tos
@export var signal_to_connect : String

## Timer used to delay loading of the new scene
var _scene_change_delay_timer : Timer

## Flag to specify if the signal has been received already (Don't kick off timer twice)
var _signal_already_received : bool = false


func _ready():
	if use_global_signal_broker_signal:
		SignalBroker.connect(signal_to_connect, self._on_signal)

func _on_signal():
	if _signal_already_received:
		return
	_signal_already_received = true
	# Start a timer to load scene
	_scene_change_delay_timer = Timer.new()
	add_child(_scene_change_delay_timer)
	_scene_change_delay_timer.timeout.connect(_load_scene)
	_scene_change_delay_timer.wait_time = scene_change_delay
	_scene_change_delay_timer.one_shot = true
	_scene_change_delay_timer.start()
	
	
func _load_scene():
	get_tree().reload_current_scene()
