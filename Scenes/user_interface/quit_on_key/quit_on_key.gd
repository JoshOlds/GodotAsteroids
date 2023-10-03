extends Node
## Quits the game when an input action event occurs

## The input action name to quit on
@export var quit_input_action_name : String = "quit"


func _input(event):
	if event.is_action_pressed(quit_input_action_name):
		get_tree().quit()
