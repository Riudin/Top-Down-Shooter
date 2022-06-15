extends CanvasLayer


onready var score_display = get_node("TopRow/H/Score")
onready var stage_display = get_node("TopRow/H/Stage")
onready var enemy_counter = get_node("TopRow/H/EnemyCounter")


func _ready():
	#Global.update_score(0)
	update_ui(0)
	Events.connect("enemy_killed", self, "update_ui")
	Events.connect("boss_killed", self, "update_ui")


func update_ui(_score):
	score_display.text = "Score: " + str(Global.score)
	stage_display.text = "Stage: " + str(Global.stage)
	enemy_counter.text = "Enemies left: " + str(Global.enemies_in_stage)

