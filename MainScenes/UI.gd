extends CanvasLayer


onready var health_display = get_node("V/TopRow/H/Health")
onready var score_display = get_node("V/TopRow/H/Score")
onready var stage_display = get_node("V/TopRow/H/Stage")
onready var enemy_counter = get_node("V/TopRow/H/EnemyCounter")

onready var boss_row = get_node("V/BossRow")
onready var boss_name_label = get_node("V/BossRow/H/BossName")
onready var boss_hp_bar = get_node("V/BossRow/H/BossHP")
onready var boss_hp_bar_label = get_node("V/BossRow/H/BossHP/Label")

var boss_max_hp
var boss_current_hp


func _ready():
	boss_row.visible = false
	#Global.update_score(0)
	update_ui(0)
	health_display.text = "Health: " + str(Global.player_health)
	Events.connect("player_health_changed", self, "update_ui")
	Events.connect("enemy_killed", self, "update_ui")
	Events.connect("boss_killed", self, "update_ui")
	Events.connect("boss_spawned", self, "show_boss_row")
	Events.connect("boss_damaged", self, "on_boss_damaged")


func update_ui(_score):
	health_display.text = "Health: " + str(Global.player_health)
	score_display.text = "Score: " + str(Global.score)
	stage_display.text = "Stage: " + str(Global.stage)
	enemy_counter.text = "Enemies left: " + str(Global.enemies_in_stage)


func show_boss_row(boss_name, boss_hp):
	boss_max_hp = boss_hp
	boss_current_hp = boss_hp
	boss_row.visible = true
	boss_name_label.text = boss_name + ":"
	boss_hp_bar.max_value = boss_hp
	boss_hp_bar.value = boss_hp
	boss_hp_bar_label.text = str(boss_current_hp) + "/" + str(boss_max_hp)


func on_boss_damaged(dmg):
	boss_current_hp -= dmg
	boss_hp_bar.value = boss_current_hp
	boss_hp_bar_label.text = str(boss_current_hp) + "/" + str(boss_max_hp)
