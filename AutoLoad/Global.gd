extends Node


#player variables
var player = null
var player_health := 4
var player_speed := 250
var player_attack_cooldown := 10

#var power_ups = [
#	"Speed",
#	"AttackSpeed",
#	"PlusLaser",
#	"Health"
#]

var score = 0
var highscore = 0
var stage = 1
var enemies_in_stage = 0

var mobile_controls = true

var save_file = "user://gamedata.save"


func _ready():
	Events.connect("power_up_taken", self, "_on_power_up_taken")
	Events.connect("player_health_changed", self, "update_health")
	Events.connect("enemy_killed", self, "update_score")
	Events.connect("boss_killed", self, "update_score")
	Events.connect("player_died", self, "reset_player_variables")


# needs a better name
func update_score(amount):
	score += amount
	
	enemies_in_stage -= 1
	enemies_in_stage = clamp(enemies_in_stage, 0, enemies_in_stage)


func _on_power_up_taken(power_up):
	match power_up:
		"Speed":
			player_speed += 10
			if player_speed >= 400:
				player_speed = 400
				#power_ups.erase("Speed")
		"AttackSpeed":
			player_attack_cooldown -= 1
			if player_attack_cooldown <= 1:
				player_attack_cooldown = 1
				#power_ups.erase("AttackSpeed")
		"PlusLaser":
			pass
		"Health":
			player_health += 1
			if player_health >= 10:
				player_health = 10
				#power_ups.erase("Health")
	Events.emit_signal("power_up_applied")


func update_health(new_health):
	player_health = new_health
	if player_health < 0:
		player_health = 0


func reset_player_variables():
	player_health = 4
	player_speed = 250
	player_attack_cooldown = 10
	
#	power_ups = [
#	"Speed",
#	"AttackSpeed",
#	"PlusLaser",
#	"Health"
#]


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
