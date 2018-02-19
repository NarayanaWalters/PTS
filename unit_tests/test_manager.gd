extends Node2D

onready var label = $ScrollContainer/Label
onready var player = $Player
onready var inventory = $Player/Inventory

var test_items = ["a_leather_vest", "a_chainmail_vest", 
"w_bronze_dagger", "w_iron_sword"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	inventory_pickup_drop_test()
	inventory_navigation_test()
	inventory_equip_unequip_test()

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
	drop_test(items_list)
	label.text += "dropping again\n"

	return true

func drop_test(var correct):
	inventory.drop_item()
	label.text += "should drop: %s\n" % correct.pop_front()
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
