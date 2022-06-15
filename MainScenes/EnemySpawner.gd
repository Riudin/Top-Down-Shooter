extends Node2D


var spawn_time = 1
var can_spawn_enemy = true setget set_can_spawn_enemy
var enemy_count = 0
var max_enemies = 5
var enemies_killed = 0

var spawn_points = []
var stage_has_boss = true
onready var boss_spawn = get_node("BossSpawn")
onready var spawn_timer = get_parent().get_node("SpawnTimer")

onready var default_enemy = preload("res://Enemies/DefaultEnemy.tscn")
onready var fast_enemy = preload("res://Enemies/FastEnemy.tscn")
onready var boss = preload("res://Enemies/FirstBoss.tscn")


func _ready():
	spawn_time -= 0.025 * Global.stage
	if spawn_time < 0.25: spawn_time = 0.25
	spawn_timer.set_wait_time(spawn_time)
	spawn_timer.start()
	
	max_enemies += round(pow(1.2, Global.stage))
	Global.enemies_in_stage = max_enemies
	if stage_has_boss: Global.enemies_in_stage += 1
# warning-ignore:return_value_discarded
	Events.connect("enemy_killed", self, "on_enemy_killed")
	for i in get_child_count():
		var spawn_point = get_node_or_null("Spawn" + str(i))
		spawn_points.append(spawn_point)


func _physics_process(_delta):
	if can_spawn_enemy and enemy_count < max_enemies:
		enemy_count += 1
		var n = round(rand_range(0,1))
		if n == 0: spawn_enemies(default_enemy)
		if n == 1: spawn_enemies(fast_enemy)
		can_spawn_enemy = false
		yield(spawn_timer, "timeout")
		can_spawn_enemy = true


func spawn_enemies(enemy_type):
	#var spawn_position: Vector2 = Vector2(rand_range(0, 320), rand_range(0, 180))
	var number = round(rand_range(1, spawn_points.size() - 1))
	var spawner = get_node("Spawn" + str(number))
	
	var new_enemy = enemy_type.instance()
	#new_enemy.connect("enemy_left_screen", get_parent().get_node("UI"), "update_score")
	new_enemy.position = spawner.get_global_position()
	add_child(new_enemy)
	Events.emit_signal("enemy_spawned")
	new_enemy.add_to_group("enemies")


func spawn_boss():
	if stage_has_boss:
		var spawner = get_node("BossSpawn")
		
		var new_boss = boss.instance()
		new_boss.position = spawner.get_global_position()
		add_child(new_boss)
		Events.emit_signal("enemy_spawned")
		new_boss.add_to_group("enemies")


func on_enemy_killed(_amount):
	enemies_killed += 1
	if enemies_killed >= max_enemies:
		spawn_boss()


func set_can_spawn_enemy(b):
	can_spawn_enemy = b
