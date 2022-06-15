extends Node


var player = null

var score = 0
var highscore = 0
var stage = 1
var enemies_in_stage = 0

func _ready():
	Events.connect("enemy_killed", self, "update_score")
	Events.connect("boss_killed", self, "update_score")


# needs a better name
func update_score(amount):
	score += amount
	
	enemies_in_stage -= 1
	enemies_in_stage = clamp(enemies_in_stage, 0, enemies_in_stage)
