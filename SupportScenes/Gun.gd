extends Node2D


signal camera_shake_requested(amplitude, duration)
# warning-ignore:unused_signal
signal frame_freeze_requested

export(float) var screenshake_amplitude = 1.0
export(float) var screenshake_duration = 0.1

export(int) var cooldown = 10
export(int) var p_range = 100
export(int) var speed = 400
export(int) var damage = 1

export(PackedScene) onready var bullet
onready var aim_pos = get_node("AimPosition")

var last_shot = 0


func _physics_process(_delta):
	last_shot += 1


func fire():
	if last_shot < cooldown: return
	else: last_shot = 0
	
	var projectile = bullet.instance()
	projectile.add_to_group("projectiles")
	#get_parent().get_parent().get_parent().get_parent().add_child(projectile)
	get_node("/root").add_child(projectile)

	projectile.add_to_group("Projectile_" + str(get_parent()))
	
	var projectile_direction = aim_pos.global_position - self.global_position

	projectile.position = self.global_position
	projectile.rotation = projectile_direction.angle()
	projectile.projectile_direction = projectile_direction
	projectile.projectile_speed = speed
	projectile.damage = damage
	projectile.projectile_range = p_range
	
	if screenshake_amplitude != 0 and screenshake_duration != 0:
		emit_signal("camera_shake_requested", screenshake_amplitude, screenshake_duration)
