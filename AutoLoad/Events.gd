extends Node


### Ingame Signals
# warning-ignore:unused_signal
signal enemy_spawned
# warning-ignore:unused_signal
signal boss_spawned()
# warning-ignore:unused_signal
signal boss_damaged(damage)
# warning-ignore:unused_signal
signal enemy_killed(score)
# warning-ignore:unused_signal
signal boss_killed(score)
# warning-ignore:unused_signal
signal player_died

### UI Signals
## warning-ignore:unused_signal
#signal movestick_moved   # for mobile controls
## warning-ignore:unused_signal
#signal attackstick_moved   # for mobile controls
# warning-ignore:unused_signal
signal gamescene_ready
# warning-ignore:unused_signal
signal game_restarted
# warning-ignore:unused_signal
signal game_ended
# warning-ignore:unused_signal
signal main_menu_new_game_pressed
# warning-ignore:unused_signal
signal main_menu_settings_pressed
# warning-ignore:unused_signal
signal main_menu_about_pressed
