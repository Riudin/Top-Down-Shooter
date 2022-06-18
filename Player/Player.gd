extends KinematicBody2D


# warning-ignore:unused_signal
signal camera_shake_requested(amplitude, duration)
# warning-ignore:unused_signal
signal frame_freeze_requested

const ACCELERATION = 4000
const FRICTION = 4000

export var max_health: int = 4
export var health: int = 4
export var max_speed := 250

var is_alive = true

#var bullet = preload("res://Player/Projectiles/Bullet.tscn")
onready var health_bar = get_node("HealthBar")

var velocity = Vector2.ZERO


func _ready():
	Global.player = self
	health_bar.max_value = max_health
	health_bar.value = max_health
	health_bar.set_as_toplevel(true)


func _exit_tree():
	Global.player = null


func _process(delta):
	health_bar.set_position(position - Vector2(12, 16))
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if is_alive:
		velocity = move_and_slide(velocity)
		look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("LMB") and is_alive:
		var gun1 = get_node_or_null("Gun1")
		if gun1: gun1.fire()


func _on_Hurtbox_body_entered(body):
	print("explode")
	if body.is_in_group("enemies"):
		apply_damage(body.damage)
		body.explode()


func apply_damage(amount):
	health -= amount
	health_bar.value = health
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
