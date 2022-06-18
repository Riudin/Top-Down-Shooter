extends Node2D
"""
Stores all Levels and randomly selects the next level everytime you advance.
"""

onready var level1 = load("res://Levels/Level1.tscn")
onready var level2 = load("res://Levels/Level2.tscn")
onready var level3 = load("res://Levels/Level3.tscn")

var _levels = []

var level_count = 3
var current_level
var player_spawn_position: Vector2


func create_level_array():
	for level in level_count:
		_levels.append("level" + str(level + 1))


func select_level():
	randomize()
	var n = randi() % level_count + 1
	current_level = load("res://Levels/Level" + str(n) + ".tscn")


func instance_level():
	var level_instance = current_level.instance()
	add_child(level_instance)
	
	var player_spawn = level_instance.get_node_or_null("PlayerSpawn")
	if not player_spawn: print("ERROR: PlayerSpawn not found")
	else: player_spawn_position = player_spawn.global_position
