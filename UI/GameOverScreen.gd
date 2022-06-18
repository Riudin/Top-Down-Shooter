extends CanvasLayer


#onready var ui = get_parent().get_node("UI")

onready var score_display = get_node("MarginContainer/ColorRect/V/Score")


func _ready():
	get_tree().paused = true
	score_display.text = "Score: " + str(Global.score)


func _on_BackButton_pressed():
	get_tree().paused = false
	Events.emit_signal("game_ended")
