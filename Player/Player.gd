extends KinematicBody2D



signal camera_shake_requested(amplitude, duration)

signal frame_freeze_requested

const ACCELERATION = 4000
const FRICTION = 4000

export var health := 4
export var max_speed := 250
export var weapon_cooldown := 10

var is_alive = true # this is so you can't move, rotate or shoot after you died. maybe stop process instead?
var mobile_controls = Global.mobile_controls

onready var left_joystick = get_parent().get_node("UI/JoystickLeft/Button")
onready var right_joystick = get_parent().get_node("UI/JoystickRight/Button")
onready var gun1 = get_node_or_null("Gun1")
onready var gun2 = get_node_or_null("Gun2")
onready var gun3 = get_node_or_null("Gun3")
onready var gun4 = get_node_or_null("Gun4")
onready var health_bar = get_node("HealthBar")

var input_vector := Vector2.ZERO
var attack_vector := Vector2.ZERO
var velocity := Vector2.ZERO


func _ready():
	Global.player = self
	#Events.emit_signal("player_health_changed", health)
	update_variables()
	print(health)
	print(max_speed)
	print(weapon_cooldown)
	health_bar.max_value = health
	health_bar.value = health
	health_bar.set_as_toplevel(true)
	
	if not mobile_controls:
		left_joystick.get_parent().visible = false
		right_joystick.get_parent().visible = false
	
	Events.connect("power_up_applied", self, "update_variables")


func _exit_tree():
	Global.player = null


func _process(delta):
	health_bar.set_position(position - Vector2(12, 16))
	
	
	if mobile_controls:
		input_vector = left_joystick.get_value()
		
	elif not mobile_controls:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		
		
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if is_alive:
		velocity = move_and_slide(velocity)
	
	if not mobile_controls and is_alive:
		look_at(get_global_mouse_position())
		
		if Input.is_action_pressed("LMB"):
			gun1 = get_node_or_null("Gun1")
			if gun1: gun1.fire()
			
	elif mobile_controls and is_alive:
		look_at(global_position + right_joystick.get_value())
		
		if right_joystick.get_value() != Vector2.ZERO:
			gun1 = get_node_or_null("Gun1")
			if gun1: gun1.fire()


func update_variables():
	health = Global.player_health
	max_speed = Global.player_speed
	weapon_cooldown = Global.player_attack_cooldown
	update_guns()


func update_guns():
	if gun1: gun1.cooldown = weapon_cooldown
	if gun2: gun2.cooldown = weapon_cooldown
	if gun3: gun3.cooldown = weapon_cooldown
	if gun4: gun4.cooldown = weapon_cooldown


func _on_Hurtbox_body_entered(body):
	print("explode")
	if body.is_in_group("enemies"):
		apply_damage(body.damage)
		body.explode()


func apply_damage(amount):
	health -= amount
	health_bar.value = health
	Events.emit_signal("player_health_changed", health)
	if health <= 0:
		health_bar.value = 0
		on_death()


func on_death():
	visible = false
	health_bar.visible = false
	is_alive = false
	Events.emit_signal("player_died")
	#play death animation
	#queue_free()


func get_class(): return "Player" # used for collision detection
func is_class(name): return name == "Player" or .is_class(name)
