extends Control


onready var mobile_controls_button = get_node("M/H/ButtonsL/MobileControls/Button")


func _ready():
	if Global.mobile_controls:
		Global.mobile_controls = !Global.mobile_controls
		mobile_controls_button.pressed = true


func _on_mobile_controls_Button_toggled(_button_pressed):
	Global.mobile_controls = !Global.mobile_controls


func _on_Back_pressed():
	Events.emit_signal("settings_menu_back_pressed")
