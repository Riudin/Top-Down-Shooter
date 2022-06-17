extends Node


export var delay_mseconds := 15


func _ready():
	#connect_frame_freezers()
# warning-ignore:return_value_discarded
	Events.connect("gamescene_ready", self, "connect_frame_freezers")
# warning-ignore:return_value_discarded
	Events.connect("enemy_spawned", self, "connect_frame_freezers")
# warning-ignore:return_value_discarded
	Events.connect("boss_spawned", self, "connect_frame_freezers")


func connect_frame_freezers(_boss_name, _boss_health): #args are only used to avoid errors when args are expected
	for frame_freezer in get_tree().get_nodes_in_group("frame_freezer"):
		if frame_freezer.is_connected("frame_freeze_requested", self, "_on_frame_freeze_requested"):
			return
		frame_freezer.connect("frame_freeze_requested", self, "_on_frame_freeze_requested")


func _on_frame_freeze_requested():
	OS.delay_msec(delay_mseconds)
