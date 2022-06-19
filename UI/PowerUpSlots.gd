extends HBoxContainer


onready var slot_1 = get_node("Slot1")
onready var slot_2 = get_node("Slot2")
onready var slot_3 = get_node("Slot3")

var slots = [slot_1, slot_2, slot_3]
var selected_power_ups = []

var power_ups = [
	"Speed",
	"AttackSpeed",
	"PlusLaser",
	"Health"
]


func _ready():
	slots = [slot_1, slot_2, slot_3]
	#power_ups = Global.power_ups
	generate_power_ups()
	initiate_power_ups()



func generate_power_ups():
	# generate 3 power ups that will be shown in the slots
	selected_power_ups = []
	var possible_power_ups = power_ups
	for slot in slots:
		randomize()
		power_ups.shuffle()
		selected_power_ups.append(possible_power_ups[0])
		possible_power_ups.remove(0)


func initiate_power_ups():
	# for each slot in the array assign one of the generated power ups
	var n = 0
	for slot in slots:
		slot.get_node("Button").texture_normal = load("res://PowerUps/Assets/" + selected_power_ups[n] + ".png")
		n += 1


#func initiate_power_ups():
#	# for each slot in the array assign one of the generated power ups
#	var n = 0
#	for slot in slots:
#		var new_power_up = load("res://PowerUps/DefaultPowerUp.tscn").instance()
#		#connect("on_button_pressed", self, "close_menu")
#		new_power_up.get_node("Icon").texture = load("res://PowerUps/Assets/" + selected_power_ups[n] + ".png")
#		slot.add_child(new_power_up)
#		n += 1


func close_menu():
	get_tree().paused = false
	Events.emit_signal("game_restarted")
	get_parent().get_parent().get_parent().get_parent().queue_free()


func _on_Slot1_Button_pressed():
	Events.emit_signal("power_up_taken", selected_power_ups[0])
	close_menu()


func _on_slot2_Button_pressed():
	Events.emit_signal("power_up_taken", selected_power_ups[1])
	close_menu()


func _on_slot3_Button_pressed():
	Events.emit_signal("power_up_taken", selected_power_ups[2])
	close_menu()
