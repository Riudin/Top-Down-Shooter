extends Area2D


var projectile_speed
var projectile_direction := Vector2.ZERO
var damage
var projectile_type
var projectile_range

var ticks = 0


func _ready():
# warning-ignore:return_value_discarded
	self.connect("area_entered", self, "_on_impact")
# warning-ignore:return_value_discarded
	self.connect("body_entered", self, "_on_impact")


func _physics_process(delta):
	ticks += 1
	if ticks > projectile_range: destroy()
	else: global_position += projectile_speed * projectile_direction * delta


func destroy():
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	destroy()


func _on_impact(target):
	if projectile_type == "friendly":
		if (target.get_class() == "Enemy"):
			target.apply_damage(damage)
	if projectile_type == "hostile":
		if (target.get_parent().get_class() == "Player"):
			target.get_parent().apply_damage(damage)
	destroy()
