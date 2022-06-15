extends Control


#onready var new_game_button = get_node("M/Buttons/NewGame")
#onready var settings_button = get_node("M/Buttons/Settings")
#onready var about_button = get_node("M/Buttons/About")
#onready var quit_button = get_node("M/Buttons/Quit")
onready var highscore_display = get_node("M/H/V/Highscore")


func _ready():
	update_highscore()
	highscore_display.text = "Highscore:\n" + str(Global.highscore)
#	new_game_button.connect("pressed", self, "_on_NewGame_pressed")
#	settings_button.connect("pressed", self, "_on_Settings_pressed")
#	about_button.connect("pressed", self, "_on_About_pressed")
#	quit_button.connect("pressed", self, "_on_Quit_pressed")


func update_highscore():
	if Global.score > Global.highscore:
		Global.highscore = Global.score


func _on_NewGame_pressed():
	Events.emit_signal("main_menu_new_game_pressed")


func _on_Settings_pressed():
	Events.emit_signal("main_menu_settings_pressed")


func _on_About_pressed():
	Events.emit_signal("main_menu_about_pressed")


func _on_Quit_pressed():
	get_tree().quit()
