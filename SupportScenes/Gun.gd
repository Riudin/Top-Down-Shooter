extends Node2D


signal camera_shake_requested(amplitude, duration)
# warning-ignore:unused_signal
signal frame_freeze_requested

export(float) var screenshake_amplitude = 1.0
export(float) var screenshake_duration = 0.1

export(int) var cooldown = 10
export(int) var projectile_range = 100
export(int) var speed = 400
export(int) var damage = 1

export(String, "friendly", "hostile") var gun_type = "friendly"

export(PackedScene) onready var bullet# = load("res://Player/Projectiles/Bullet.tscn")
onready var aim_pos = get_node("AimPosition")
#onready var self_pos = null

var projectiles = []
var last_shot = 0


func fire(_s, gun_slot = self):
	if last_shot < cooldown: return
	else: last_shot = 0
	
	#var velocity = Vector2()
	var projectile = bullet.instance()
	#projectile.add_collision_exception_sdwith(s)
	projectile.add_to_group("projectiles")
	#get_parent().get_parent().get_parent().get_parent().add_child(projectile)
	get_node("/root").add_child(projectile)
#	if has_gun_pivot:
#		projectile.add_to_group("Projectile_" + str(get_parent().get_parent()))
#	else:
	projectile.add_to_group("Projectile_" + str(get_parent()))
	
	#print(projectile.get_groups())
	
	#self_pos = self.position
	#aim_pos = get_parent().position
	var projectile_direction = aim_pos.global_position - gun_slot.global_position
#	if has_gun_pivot:
#		projectile.rotation = gun_pivot.rotation
#	else:
	projectile.projectile_direction = projectile_direction
	projectile.rotation = projectile_direction.angle()
	projectile.position = gun_slot.global_position
	projectile.projectile_speed = speed
	projectile.damage = damage
	projectile.projectile_type = gun_type
	projectile.projectile_range = projectile_range
	
	#velocity = Vector2(speed, 0).rotated(projectile.rotation)
	
#	projectiles.append({
#		"projectile": projectile,
#		#"velocity": velocity,
#		"ticks": 0
#	})
#
	if screenshake_amplitude != 0 and screenshake_duration != 0:
		emit_signal("camera_shake_requested", screenshake_amplitude, screenshake_duration)


func _physics_process(_delta):
	last_shot += 1
#	for i in projectiles:
#		var p = i["projectile"]
#
#		if i["ticks"] >= projectile_range:
#			p.queue_free()
#			projectiles.erase(i)
		
#		var collision = p.move_and_collide(i["velocity"] * delta)
#
#		if (collision):
#			var collider = collision.collider
#			if gun_type == "friendly":
#				if (collider.get_class() == "Enemy"):
#					collider.apply_damage(damage)
#			if gun_type == "hostile":
#				if (collider.get_class() == "Player"):
#					collider.apply_damage(damage)
#			p.queue_free()
#			projectiles.erase(i)
#		i["ticks"] += 1

