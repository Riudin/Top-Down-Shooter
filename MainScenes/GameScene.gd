extends Node2D


onready var player = load("res://Player/Player.tscn")
onready var game_over_screen = load("res://UI/GameOverScreen.tscn")
onready var victory_screen = load("res://UI/VictoryScreen.tscn")
onready var level_manager = get_node("LevelManager")

var player_spawn_point := Vector2.ZERO

var time_start = 0
var time_now = 0
var playtime = 0 setget , get_playtime


func _ready():
	randomize()
# warning-ignore:return_value_discarded
	Events.connect("player_died", self, "game_over")
# warning-ignore:return_value_discarded
	Events.connect("boss_killed", self, "on_victory")
	
	initiate_level()
	initiate_player()
	
	
	time_start = OS.get_unix_time()
	
	var _arg1
	var _arg2
	Events.emit_signal("gamescene_ready", _arg1, _arg2)


func initiate_level():
	level_manager.create_level_array()
	level_manager.select_level()
	level_manager.instance_level()


func initiate_player():
	var new_player = player.instance()
	new_player.position = level_manager.player_spawn_position
	call_deferred("add_child", new_player)


func game_over():
	time_now = OS.get_unix_time()
	playtime = time_now - time_start
	var new_game_over_screen = game_over_screen.instance()
	
	yield(get_tree().create_timer(1), "timeout")
	call_deferred("add_child", new_game_over_screen)


func on_victory(_x):
	time_now = OS.get_unix_time()
	playtime = time_now - time_start
	add_time_score()
	Global.stage += 1
	var new_victory_screen = victory_screen.instance()
	
	yield(get_tree().create_timer(1), "timeout")
	add_child(new_victory_screen)


func add_time_score():
	var time_score = 0
	time_score = -0.05 * pow(playtime, 1.5) + 100 + Global.stage * 8
	if time_score <= 0:
		time_score = 0
	else:
		time_score = round(time_score)
	Global.score += time_score


func get_playtime():
	return playtime


# not used yet
func time_convert(time_in_sec):
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60

	#returns a string with the format "MM:SS"
	return "%02d:%02d" % [minutes, seconds]
