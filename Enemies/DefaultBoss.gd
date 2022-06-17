extends "res://Enemies/Enemy.gd"


var b = true
var c = true

func _physics_process(_delta):
	if b:
		shoot_circle(20, gun1)
		b= false
		yield(get_tree().create_timer(1), "timeout")
		b = true
	
	if c:
		shoot_wave(40, gun3)
		c = false
		yield(get_tree().create_timer(6), "timeout")
		c = true

