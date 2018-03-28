extends Node2D

onready var label = $CanvasLayer/ScrollContainer/Label
onready var player = $Player
onready var inventory = $Player/Inventory
onready var inv_audio_manager = $Player/Inventory/AudioController

var test_items = ["a_leather_vest", "a_chainmail_vest", 
"w_bronze_dagger", "w_iron_sword"]



func _ready():
	yield(get_tree(), "idle_frame")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	label.text = ""
	all_numbers_output_test(true)
	#inventory_pickup_drop_test()
	#inventory_navigation_test()
	#inventory_equip_unequip_test()

const nums_to_test = {
-1: ["overflow"],
0: ["zero"], 
1: ["one"], 
12: ["twelve"], 
15: ["fifteen"], 
20: ["twenty"], 
21: ["twenty", "one"], 
32: ["thirty", "two"], 
99: ["ninety", "nine"],
100: ["one", "hundred"], 
108: ["one", "hundred", "eight"], 
200: ["two", "hundred"], 
305: ["three", "hundred", "five"], 
373: ["three", "hundred", "seventy", "three"],
999: ["nine", "hundred", "ninety", "nine"],
1000: ["overflow"]}

func all_numbers_output_test(var use_audio):
	label.text += "BEGIN NUMBER OUTPUT TESTS\n"
	var fails = 0
	for key in nums_to_test.keys():
		var b = number_output_test(key, nums_to_test[key], use_audio)
		if !b:
			fails += 1
	label.text += "NUMBER OUTPUT TESTS COMPLETE failed: %s\n" % fails

func number_output_test(var num, var correct, var use_audio):
	
	if use_audio:
		inv_audio_manager.play_number(num)
	var result = inv_audio_manager.num_to_str_array(num)
	if result != correct:
		label.text += "FAILED NUM TEST: num %s : output %s : correct %s \n" % [num, result, correct]
	else:
		label.text += "passed: %s %s\n" % [num, result]
	
	return result == correct
	


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
