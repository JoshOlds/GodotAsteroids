extends Node
class_name LevelupManager

## The levelup scene to instantiate when player levels up
var packed_levelup_scene : PackedScene = preload("res://scenes/user_interface/level_up/level_up_selection_scene.tscn")

## Node to parent the LevelupScene to when it is instantiated
@export var levelup_scene_parent : Node

## Modifiers to apply level up selection to
@export var modifiers : Modifiers

## The instanced LevelupScene - instantiated when player levels up, killed when level up complete
var instanced_levelup_scene : LevelupScene


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	SignalBroker.player_level_up.connect(_on_player_levelup)
	SignalBroker.apply_levelup_modifier.connect(_on_apply_levelup_modifier)
	SignalBroker.level_up_selection_complete.connect(_on_level_up_selection_complete)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_player_levelup(_previous_level : int, _new_level : int):
	# Pause the game, spawn the levelup scene, wait for levelup complete signal
	get_tree().paused = true
	instanced_levelup_scene = packed_levelup_scene.instantiate()
	levelup_scene_parent.add_child(instanced_levelup_scene)
	
	
func _on_apply_levelup_modifier(modifier : ModifierBase):
	modifier.apply_modifier(modifiers)
	

func _on_level_up_selection_complete():
	instanced_levelup_scene.queue_free()
	get_tree().paused = false
