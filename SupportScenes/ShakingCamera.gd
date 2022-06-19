extends Camera2D

onready var timer : Timer = $Timer

export var amplitude : = 6.0
export var duration : = 0.8 setget set_duration
export(float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake


func _ready():
	randomize()
	set_process(false)
	self.duration = duration

	Events.connect("gamescene_ready", self, "connect_to_shakers")

	Events.connect("enemy_spawned", self, "connect_to_shakers")

	Events.connect("boss_spawned", self, "connect_to_shakers")
	#connect_to_shakers()


func _process(_delta):
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)


func _on_ShakeTimer_timeout():
	self.shake = false


func _on_camera_shake_requested(amp, dur):
	self.amplitude = amp
	self.duration = dur
	
	if amp >= self.amplitude: 
		set_process(false)
	if dur >= self.duration: 
		set_process(false)
	
	self.shake = true

func set_duration(value: float):
	duration = value
	timer.wait_time = duration


func set_shake(value: bool):
	shake = value
	set_process(shake)
	offset = Vector2()
	if shake:
		timer.start()


func connect_to_shakers(_boss_name, _boss_health): #args are only used to avoid errors when args are expected
	for camera_shaker in get_tree().get_nodes_in_group("camera_shaker"):
		if camera_shaker.is_connected("camera_shake_requested", self, "_on_camera_shake_requested"):
			return
		camera_shaker.connect("camera_shake_requested", self, "_on_camera_shake_requested")
