extends Node2D

onready var label = $CanvasLayer/ScrollContainer/Label
onready var player = $Player
onready var echolocator = $Player/Echolocator
onready var inventory = $Player/Inventory
onready var stats = $Player/Inventory/Stats
onready var inv_audio_manager = $Player/Inventory/AudioController

var test_items = ["a_leather_vest", "a_chainmail_vest", 
"w_bronze_dagger", "w_iron_sword"]
var fails = 0


func _ready():
	yield(get_tree(), "idle_frame")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	label.text = ""
	complete_numbers_output_test(false)
	complete_inv_audio_tests()
	
	echo_test()

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

func complete_numbers_output_test(var use_audio):
	label.text += "\nBEGIN NUMBER OUTPUT TESTS\n"
	fails = 0
	for key in nums_to_test.keys():
		number_output_test(key, nums_to_test[key], use_audio)

	label.text += "NUMBER OUTPUT TESTS COMPLETE failed: %s\n" % fails

func number_output_test(var num, var correct, var use_audio):
	if use_audio:
		inv_audio_manager.play_number(num)
	var result = inv_audio_manager.num_to_str_array(num)
	if result != correct:
		fails += 1
		label.text += "FAILED NUM TEST: num %s : output %s : correct %s \n" % [num, result, correct]
	else:
		label.text += "passed: %s %s\n" % [num, result]
	
	return result == correct

var test_items_for_audio = ["a_leather_vest", "a_chainmail_vest", "w_bronze_dagger", "w_bow"]

func complete_inv_audio_tests():
	stats.stats["melee"] = 0
	stats.skill_points = 1
	
	var bow_dam = "seven"
	var bow_atk_rate = "eight"
	reset_inv()
	var correct = []
	fails = 0
	label.text += "\nBEGIN INVENTORY AUDIO TESTS\n"
	inventory.pickup_items(test_items_for_audio)
	correct = ["bow", "sword", "armor","armor", "picked_up"]
	inventory_audio_test(correct)
	inventory.open(true)
	correct = [bow_atk_rate, "attack_rate", bow_dam, "damage","bow", "backpack"]
	inventory_audio_test(correct)
	
	inventory.tab_right()
	correct = ["zero", "melee", "one", "skill_points", "stats"]
	inventory_audio_test(correct)
	
	inventory.tab_left()
	correct = [bow_atk_rate, "attack_rate", bow_dam, "damage","bow", "backpack"]
	inventory_audio_test(correct)
	
	inventory.row_down()
	inventory.row_down()
	inventory.drop_item()
	correct = ["armor", "dropped"]
	inventory_audio_test(correct)
	inventory.row_up()
	inventory.equip_unequip_item()
	correct = ["sword", "equipped"]
	inventory_audio_test(correct)
	inventory.row_up()
	inventory.equip_unequip_item()
	correct = ["sword", "unequipped", "bow", "equipped"]
	inventory_audio_test(correct)
	
	inventory.tab_left()
	correct = [bow_atk_rate, "attack_rate", bow_dam, "damage","bow", "equipment"]
	inventory_audio_test(correct)
	
	inventory.tab_left()
	correct = ["movement", "journal"]
	inventory_audio_test(correct)
	inventory.tab_left()
	correct = ["zero", "melee", "one", "skill_points", "stats"]
	inventory_audio_test(correct)
	inventory.open(false)
	label.text += "INVENTORY AUDIO TESTS COMPLETE failed: %s\n" % fails

func inventory_audio_test(var correct):
	var result = []
	for snd in inv_audio_manager.sound_queue:
		result.append(snd.get_file().get_basename())
	var b = result == correct
	if !b:
		fails += 1
		label.text += "FAILED output %s correct %s \n" % [result, correct]
	else:
		label.text += "passed output %s\n" % [result]
	return b
	


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

func reset_inv():
	inventory.clear()
	inv_audio_manager.clear_sound_queue()

const cor_echo_results = ["aa", "aa", "aa", "ee", "ee", "ee", "oo", "oo"]
var echo_results = []
func echo_test():
	echolocator.connect("click", self, "add_echo")
	echo_results = []
	label.text += "\nBegin Echolocate Tests \n"
	
	echolocator.perform_echolocate()
	player.position -= Vector2(0, 14)
	echolocator.perform_echolocate()
	player.position -= Vector2(0, 5)
	echolocator.perform_echolocate()
	player.position -= Vector2(0, 16)
	echolocator.perform_echolocate()
	player.position -= Vector2(0, 32)
	echolocator.perform_echolocate()
	player.position -= Vector2(0, 48)
	echolocator.perform_echolocate()
	player.position -= Vector2(0, 16)
	echolocator.perform_echolocate()
	player.position -= Vector2(0, 16)
	echolocator.perform_echolocate()
	
	var passed = cor_echo_results == echo_results
	if passed:
		label.text += "PASSED"
	else:
		label.text += "FAILED: correct result: " + str(cor_echo_results) + "\n"
	label.text += " results of your echo test : " + str(echo_results)

func add_echo(var snd):
	echo_results.push_back(snd)
