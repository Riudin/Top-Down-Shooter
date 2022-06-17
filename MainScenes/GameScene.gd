extends Node2D


onready var player = get_node("Player")
onready var game_over_screen = load("res://UI/GameOverScreen.tscn")
onready var victory_screen = load("res://UI/VictoryScreen.tscn")

var time_start = 0
var time_now = 0
var playtime = 0 setget set_playtime, get_playtime


func _ready():
	randomize()
# warning-ignore:return_value_discarded
	Events.connect("player_died", self, "game_over")
# warning-ignore:return_value_discarded
	Events.connect("boss_killed", self, "on_victory")
	
	time_start = OS.get_unix_time()
	
	var _arg1
	var _arg2
	Events.emit_signal("gamescene_ready", _arg1, _arg2)


func on_victory(_x):
	time_now = OS.get_unix_time()
	playtime = time_now - time_start
	add_time_score()
	Global.stage += 1
	var new_victory_screen = victory_screen.instance()
	
	yield(get_tree().create_timer(1), "timeout")
	add_child(new_victory_screen)


func game_over():
	time_now = OS.get_unix_time()
	playtime = time_now - time_start
	var new_game_over_screen = game_over_screen.instance()
	
	yield(get_tree().create_timer(1), "timeout")
	call_deferred("add_child", new_game_over_screen)
	#add_child(new_game_over_screen)


func add_time_score():
	var time_score = 0
	time_score = -0.05 * pow(playtime, 1.5) + 100 + Global.stage * 8
	if time_score <= 0:
		time_score = 0
	else:
		time_score = round(time_score)
	Global.score += time_score


func set_playtime(time):
	playtime = time


func get_playtime():
	return playtime


# not used yet
func time_convert(time_in_sec):
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60

	#returns a string with the format "MM:SS"
	return "%02d:%02d" % [minutes, seconds]
