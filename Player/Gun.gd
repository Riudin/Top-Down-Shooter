extends Node2D


var bullet = load("res://Player/Projectiles/Bullet.tscn")
onready var aim_pos = null
onready var self_pos = null

var projectiles = []
var cooldown = 10
var last_shot = 0
var projectile_range = 100

var speed = 400
var damage = 1


func fire(s, gun_slot = self):
	if last_shot < cooldown: return
	else: last_shot = 0
	
	var velocity = Vector2()
	var projectile = bullet.instance()
	projectile.add_collision_exception_with(s)
	projectile.add_to_group("projectiles")
	get_node("/root").add_child(projectile)
	
	self_pos = self.position
	aim_pos = get_parent().position
	projectile.rotation = s.rotation
	projectile.position = gun_slot.global_position
	
	velocity = Vector2(speed, 0).rotated(projectile.rotation)
	
	projectiles.append({
		"projectile": projectile,
		"velocity": velocity,
		"ticks": 0
	})


func _physics_process(delta):
	last_shot += 1
	for i in projectiles:
		var p = i["projectile"]
		
		if i["ticks"] >= projectile_range:
			p.queue_free()
			projectiles.erase(i)
		
		var collision = p.move_and_collide(i["velocity"] * delta)
		
		if (collision):
			var collider = collision.collider
			if (collider.get_class() == "Enemy"):
				collider.apply_damage(damage)
			p.queue_free()
			projectiles.erase(i)
		i["ticks"] += 1

