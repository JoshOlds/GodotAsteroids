class_name PlayerExperienceBar
extends Control

## The progress bar to update with experience values
@export var progress_bar : ProgressBar

## The Label to display textual experience values
@export var label : Label


func _ready():
	# Connect signals
	SignalBroker.player_experience_changed.connect(_on_player_experience_changed)
	SignalBroker.player_level_up.connect(_on_player_level_up)

	label.text = str(1)

func _on_player_experience_changed(_prev_value : int, new_value : int, experience_to_next_level : int):
	progress_bar.max_value = experience_to_next_level
	progress_bar.value = new_value
	

func _on_player_level_up(_prev_level : int, new_level : int):
	label.text = str(new_level)