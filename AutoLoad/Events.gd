extends Node


### Ingame Signals
signal enemy_spawned 
signal boss_spawned() 
signal boss_damaged(damage) 
signal enemy_killed(score) 
signal boss_killed(score)
signal player_health_changed
signal player_died
signal player_speed_maxed
signal player_attack_speed_maxed
signal player_health_maxed

### UI Signals
signal gamescene_ready 
signal power_up_taken
signal power_up_applied
signal game_restarted 
signal game_ended 
signal main_menu_new_game_pressed 
signal main_menu_settings_pressed 
signal main_menu_about_pressed 
signal settings_menu_back_pressed
