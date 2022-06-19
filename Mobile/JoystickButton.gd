extends TouchScreenButton


var radius = Vector2(32, 32)
var boundary = 64

var ongoing_drag = -1

var return_accel = 20

var threshhold = 10


func _process(delta):
	if ongoing_drag == -1:
		var pos_difference = (Vector2.ZERO - radius) - position
		position += pos_difference * return_accel * delta


func get_button_pos():
	return position + radius


func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_center = (event.position - get_parent().global_position).length()
		
		if event_dist_from_center <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			set_global_position(event.position - radius * global_scale)
			
			if get_button_pos().length() > boundary:
				set_position(get_button_pos().normalized() * boundary - radius)
			
			ongoing_drag = event.get_index()
			
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1


func get_value():
	if get_button_pos().length() > threshhold:
		return get_button_pos() / boundary # instead of / boundary we could use .normalized() to always go full speed
	return Vector2.ZERO
	
	
	
