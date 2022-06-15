extends Node


signal all_scenes_deleted


func _ready():
	Events.connect("game_restarted", self, "start_game")
	Events.connect("game_ended", self, "show_main_menu")
	Events.connect("main_menu_new_game_pressed", self, "start_game")
	Events.connect("main_menu_settings_pressed", self, "show_settings")
	Events.connect("main_menu_about_pressed", self, "show_about")
	show_main_menu()


func delete_active_scenes():
	var active_scenes = get_tree().get_nodes_in_group("active_scenes")
	var active_projectiles = get_tree().get_nodes_in_group("projectiles")
	var active_enemies = get_tree().get_nodes_in_group("enemies")
	for i in active_scenes:
		i.queue_free()
	for i in active_projectiles:
		i.queue_free()
	for i in active_enemies:
		i.queue_free()


func reset_progress():
	Global.stage = 1
	Global.score = 0


func start_game():
	delete_active_scenes()
	yield(get_tree().create_timer(0.1), "timeout")
	var game_scene = load("res://MainScenes/GameScene.tscn").instance()
	add_child(game_scene)
	game_scene.add_to_group("active_scenes")


func show_main_menu():
	delete_active_scenes()
	yield(get_tree().create_timer(0.1), "timeout")
	var main_menu_scene = load("res://UI/MainMenu.tscn").instance()
	add_child(main_menu_scene)
	main_menu_scene.add_to_group("active_scenes")
	reset_progress()


func show_settings():
	pass


func show_about():
	pass
