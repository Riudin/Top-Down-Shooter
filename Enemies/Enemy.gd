extends KinematicBody2D
class_name Enemy


signal camera_shake_requested(amplitude, duration)
signal frame_freeze_requested

var velocity = Vector2()
var stun = false

#export(int) var max_health = 4
export(int) var health = 4
export(int) var speed = 50
export(int) var damage = 2
export(int) var score = 10
export(Color) var blood_color = Color("f9133e")
export(String, "normal", "boss") var enemy_type = "normal"
export(String) var boss_name = null


var path: Array = []
var level_navigation: Navigation2D = null
var player = null
var gun1 = null
var gun2 = null
var gun3 = null
var gun4 = null

var blood_particles = preload("res://Enemies/BloodParticles.tscn")

onready var health_bar = get_node("HealthBar")
onready var sprite = get_node("Sprite")
onready var movement_path = get_node("Line2D")
onready var soft_collision = get_node("SoftCollision")
onready var camera = Global.player.get_node("Camera2D")
#onready var pathfinding_timer = get_node("PathfindingTimer")


func _ready():
	get_weapons()
	#sprite.color = enemy_color
	score *= round(pow(1.1, Global.stage))
	damage *= round(pow(1.23, Global.stage))
	health *= pow(1.23, Global.stage)
	health = int(health) # not sure yet if we want health only as ints
	health_bar.max_value = health
	health_bar.value = health
	health_bar.set_as_toplevel(true)
	if enemy_type == "normal": boss_name = null
	
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("Navigation"):
		level_navigation = tree.get_nodes_in_group("Navigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]


func _process(_delta):
	movement_path.global_position = Vector2.ZERO
	move()
	
	health_bar.set_position(position - Vector2(8, 14))


func _physics_process(_delta):
	if player and level_navigation:
		generate_path()
		navigate()
	
	if enemy_type == "normal":
		shoot_normally()


func get_weapons():
	gun1 = get_node_or_null("Gun1")
	if gun1 == null: gun1 = get_node_or_null("GunPivot/Gun1")
	gun2 = get_node_or_null("Gun2")
	if gun2 == null: gun2 = get_node_or_null("GunPivot/Gun2")
	gun3 = get_node_or_null("Gun3")
	if gun3 == null: gun3 = get_node_or_null("GunPivot/Gun3")
	gun4 = get_node_or_null("Gun4")
	if gun4 == null: gun4 = get_node_or_null("GunPivot/Gun4")


func shoot_normally():
	if gun1: gun1.fire(self)
	if gun2: gun2.fire(self)
	if gun3: gun3.fire(self)
	if gun4: gun4.fire(self)


func shoot_circle(shots, gun):
	var rot_value = 360 / shots
	
	if gun == null: return
	for n in shots:
		#yield(get_tree(), "idle_frame")
		gun.fire(self)
		gun.rotation_degrees += rot_value


func shoot_wave(shots, gun):
	var rot_dir = 0
	var rot_value = 180 / shots
	
	if gun == null: return
	for n in shots:
		yield(get_tree().create_timer(0.1), "timeout")
		
		if gun.rotation_degrees > 45 and rot_dir == 0: 
			rot_dir = 1
		elif gun.rotation_degrees < -45 and rot_dir == 1: 
			rot_dir = 0
		
		if rot_dir == 0:
			gun.rotation_degrees += rot_value
		elif rot_dir == 1:
			gun.rotation_degrees -= rot_value
		
		gun.fire(self)


func navigate():
	if path.size() > 1:
		velocity = global_position.direction_to(path[1])
		#look_at(path[1])
		look_at(player.get_global_position())
		
		#If the destination is reched, remove the position from the array
#		if global_position.distance_to(path[0]) < 1:
#			path[0] += 1
		if global_position == path[0]:
			path.pop_front()


func generate_path():
	if level_navigation != null and player != null:
		path = level_navigation.get_simple_path(global_position, player.global_position, false)
		movement_path.points = path


func move():
#	if Global.player != null and stun == false:
#		velocity = global_position.direction_to(Global.player.global_position)
#		look_at(Global.player.global_position)
#		velocity = velocity.normalized() * speed
#	elif stun:
#		velocity = lerp(velocity, Vector2.ZERO, 0.3)
	if stun == false:
		velocity = velocity.normalized() * speed
		if soft_collision.is_colliding():
			velocity += soft_collision.get_push_vector() * 25
		velocity = move_and_slide(velocity)
	elif stun:
		velocity = lerp(velocity, Vector2.ZERO, 0.6)


func apply_damage(dmg):
	emit_signal("frame_freeze_requested")
	health -= dmg
	if enemy_type == "normal":
		health_bar.visible = true
		health_bar.value = health
	elif enemy_type == "boss":
		Events.emit_signal("boss_damaged", dmg)
	if stun == false:
		apply_stun(0.1)
	if health <= 0:
		on_destroy()


func apply_stun(time):
	velocity = - velocity * 4
	sprite.modulate = Color.red
	stun = true
	$StunTimer.set_wait_time(time)
	$StunTimer.start()


func _on_StunTimer_timeout():
	sprite.modulate = Color.white
	stun = false


func on_destroy():
	var owned_projectiles = get_tree().get_nodes_in_group("Projectile_" + str(self))
	for p in owned_projectiles:
		p.queue_free()
	
	if enemy_type == "normal":
		Events.emit_signal("enemy_killed", score)
		emit_signal("camera_shake_requested", 3, 0.2)
		emit_signal("frame_freeze_requested")
	if enemy_type == "boss":
		Events.emit_signal("boss_killed", score)
		emit_signal("camera_shake_requested", 6, 3)
		emit_signal("frame_freeze_requested")
	
	if get_parent() != null:
		var new_blood_particles = blood_particles.instance()
		new_blood_particles.position = position
		new_blood_particles.rotation = velocity.angle()
		new_blood_particles.modulate = blood_color
		get_parent().add_child(new_blood_particles)
	queue_free()


func get_class(): return "Enemy" # used for collision detection
func is_class(name): return name == "Enemy" or .is_class(name)
