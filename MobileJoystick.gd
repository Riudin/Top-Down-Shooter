extends CanvasLayer


var move_vector = Vector2.ZERO
var attack_vector = Vector2.ZERO
#var joystick_active = false

onready var texture_center = $TouchScreenButton.position + Vector2(64, 64)
onready var texture_center2 = $TouchScreenButton2.position + Vector2(64, 64)


func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if event.position.x < 320:
			if $TouchScreenButton.is_pressed():
				move_vector = calculate_move_vector(event.position)
				$InnerCircle.position = event.position
				#$InnerCircle.position = (event.position - texture_center).normalized()
				$InnerCircle.visible = true
				#joystick_active = true
		else:
			if $TouchScreenButton2.is_pressed():
				attack_vector = calculate_attack_vector(event.position)
				$InnerCircle2.position = event.position
				$InnerCircle2.visible = true
				#joystick_active = true
				
	if event is InputEventScreenTouch:
		if event.pressed == false:
			move_vector = Vector2.ZERO
			attack_vector = Vector2.ZERO
			$InnerCircle.visible = false
			$InnerCircle2.visible = false
			#joystick_active = false


func _physics_process(_delta):
	#if joystick_active:
	Events.emit_signal("movestick_moved", move_vector)
	Events.emit_signal("attackstick_moved", attack_vector)


func calculate_move_vector(event_position):
	return (event_position - texture_center).normalized()


func calculate_attack_vector(event_position):
	return (event_position - texture_center).normalized()
