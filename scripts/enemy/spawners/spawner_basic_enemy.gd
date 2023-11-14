extends Node
class_name SpawnerBasicEnemy

## The target of all spawned BasicEnemys
@export var target_ref : Node2D

## The node that all spawned enemys will be parented to
@export var spawn_parent_ref : Node

## Spawn interval TODO this value does not set the timer - maybe get rid of this after testing
@export var spawn_interval_seconds : float

var basic_enemy_scene : PackedScene = preload("res://scenes/enemies/basic_enemy.tscn")

var spawn_timer : Timer


func _ready():
	spawn_timer = Timer.new()
	spawn_timer.timeout.connect(spawn_random_position)
	add_child(spawn_timer)
	if spawn_interval_seconds > 0:
		spawn_on_interval(spawn_interval_seconds)


func spawn_on_interval(spawn_interval_seconds : float):
	spawn_timer.wait_time = spawn_interval_seconds
	if spawn_timer.is_stopped():
		spawn_timer.start()


func spawn_random_position():
	var position = Vector2(randf_range(-1000,1000), randf_range(-1000, 1000))
	spawn(position)


func spawn(spawn_position : Vector2):
	var enemy = basic_enemy_scene.instantiate() as BasicEnemy
	enemy.target_ref = target_ref
	enemy.attack_distance = 100
	spawn_parent_ref.add_child(enemy)
	
