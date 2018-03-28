extends Node2D

onready var label = $ScrollContainer/Label
onready var player = $Player
onready var inventory = $Player/Inventory
onready var inv_audio_manager = $Player/Inventory/AudioController

var test_items = ["a_leather_vest", "a_chainmail_vest", 
"w_bronze_dagger", "w_iron_sword"]



func _ready():
	yield(get_tree(), "idle_frame")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	number_output_init()
	#inventory_pickup_drop_test()
	#inventory_navigation_test()
	#inventory_equip_unequip_test()


var num_count_timer = null
const max_number_to_test = 400
var test_number = 320

func number_output_init():
	num_count_timer = Timer.new()
	#num_count_timer.one_shot = true
	num_count_timer.wait_time = 1
	#num_count_timer.set_one_shot(true)
	num_count_timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	num_count_timer.connect("timeout", self, "number_output_test")
	num_count_timer.start()
	add_child(num_count_timer)

func number_output_test():
	if test_number > max_number_to_test:
		num_count_timer.stop()
		remove_child(num_count_timer)
		num_count_timer.queue_free()
		return
	inv_audio_manager.play_number(test_number)
	test_number += 1
	


#TODO
#add items, drop them, check they appear in world
#check they are in inv when picked up
#check for duplication
func inventory_pickup_drop_test():
	var items_list = []
	for item in test_items:
		items_list.push_front(item)
	inventory.clear()
	label.text = "INVENTORY TEST #1: pickup/drop items \n"
	label.text += "picking up: " + str(items_list) + "\n"
	inventory.pickup_items(test_items)
	var contents = inventory.get_contents_of_backpack()
	label.text += "contents now: " + str(contents) + "\n"
	var res = match_two_arrays(contents, items_list)
	if !res:
		return false
	label.text += "all items accounted for\n"
	inventory.tab_right()
	drop_test(items_list, 0)
	yield(get_tree(), "idle_frame")
	inventory.row_down()
	#drop at edge and drop from nothing
	for i in [1, 1, 0, 0]:
		res = drop_test(items_list, i)
		if !res:
			label.text += "ERROR IN DROP TEST"
			return false
		yield(get_tree(), "idle_frame")
	return true

func drop_test(var correct, var index):
	inventory.drop_item()
	if correct.size() > 0:
		label.text += "dropping: %s\n" % correct[index]
		correct.remove(index)
	else:
		label.text += "dropping: nothing\n"
	var current = inventory.get_contents_of_backpack()
	display_contents(current, correct)
	var res = match_two_arrays(current, correct)
	return res

func match_two_arrays(var current, var correct):
	for i in current.size():
		if current[i] != correct[i]:
			var txt =  "ERROR: items not matched, current: %s, correct: %s \n"
			label.text += txt % [current[i], correct[i]]
			return false
	return true

#match two arrays mirrored (e.g. item at index 0 of first array
# should equal item at index n - 1 of second array)
func mirror_match(var l1, var l2):
	var d_l2 = l2.duplicate()
	for item in l1:
		if item != d_l2.pop_back():
			label.text += "ERROR: item not matched: " + item + "\n"
			return false
	return true

#for printing out contents of two arrays
func display_contents(var current, var correct):
	label.text += "current contents are : " + str(current) + "\n"
	label.text += "correct contents are : " + str(correct) + "\n"

#TODO
#move around, test positions
func inventory_navigation_test():
	pass

#TODO
func inventory_equip_unequip_test():
	pass


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
