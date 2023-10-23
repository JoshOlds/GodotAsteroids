extends Node

@export var pause_input : String = "pause" 

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("pause"):
		pause_unpause_game()

func pause_unpause_game():
	get_tree().paused = not get_tree().paused
