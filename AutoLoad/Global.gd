extends Node


var player = null

var score = 0
var highscore = 0
var stage = 1
var enemies_in_stage = 0

var mobile_controls = true

var save_file = "user://gamedata.save"


func _ready():
	Events.connect("enemy_killed", self, "update_score")
	Events.connect("boss_killed", self, "update_score")


# needs a better name
func update_score(amount):
	score += amount
	
	enemies_in_stage -= 1
	enemies_in_stage = clamp(enemies_in_stage, 0, enemies_in_stage)


func save_game():
	var f = File.new()
	f.open(save_file, File.WRITE)
	
	f.store_line(to_json(highscore))
	f.store_line(to_json(mobile_controls))
	
	f.close()
	
	print("Game Saved")


func load_game():
	var f = File.new()
	if not f.file_exists(save_file):
		print("File gamedata.save not found")
		return
	
	f.open(save_file, File.READ)
	
	highscore = parse_json(f.get_line())
	mobile_controls = parse_json(f.get_line())
	
	f.close()
	
	print("Game Loaded")
