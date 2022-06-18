extends "res://Enemies/Enemy.gd"


onready var gun1_cd = $Gun1CooldownTimer
onready var gun2_cd = $Gun2CooldownTimer


func _on_Gun1CooldownTimer_timeout():
	shoot_circle(20, gun1)


func _on_Gun2CooldownTimer_timeout():
	shoot_wave(40, gun2)
