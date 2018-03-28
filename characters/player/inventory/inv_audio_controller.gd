extends AudioStreamPlayer

onready var db = get_node("/root/entity_database")

var audio_path = "res://audio/inventory/"
var open_sound = "open_inventory"

var tabs_sounds = ["equipment", "backpack", "stats", "journal"]

var close_sound = "close_inventory"
var atk_rate_sound = "swishes2"
var sound_queue = []

var drop_sound = "metal_clash"

const single_dig_numbers = ["zero", "one", "two", "three", 
"four", "five", "six", "seven", "eight", "nine"]
const teen_numbers = ["ten", "eleven", "twelve", "thirteen",
 "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
const double_dig_numbers = ["twenty", "thirty", "forty", "fifty",
"sixty", "seventy", "eighty", "ninety"]
const number_overflow = "overflow"
const hundred_number = "hundred"

func _ready():
	pass

func _process(delta):
	if sound_queue.size() > 0 and !playing:
		stream = load(sound_queue.pop_back())
		play()

func clear_sound_queue():
	sound_queue.clear()
	stop()

#for passing sounds without paths
func add_sound_to_queue(var sound):
	sound_queue.push_front(audio_path + sound + ".wav")

func open():
	clear_sound_queue()
	add_sound_to_queue("tabs/" + tabs_sounds[1])

func close():
	clear_sound_queue()
	add_sound_to_queue(close_sound)

func play_tab_sound(var tab):
	if tab >= 0 and tab <= 3: #paper_doll
		add_sound_to_queue("tabs/" + tabs_sounds[tab])

# plays id sounds and stats for this item
func play_item_stats(var item_id):
	
	if item_id == null or item_id == "":
		return
	var item_info = db.get_item(item_id)
	#play_item_id_sound(item_id)
	
	if item_info.has("type"):
		var type = item_info["type"]
		if type == "weapon":
			sound_queue.push_front(item_info["sounds"]["unsheathe"])
			play_number(item_info["damage"])
			add_sound_to_queue(atk_rate_sound)
			play_number(item_info["attack_rate"])
		elif type == "armor":
			sound_queue.push_front(item_info["sounds"]["equip"])
			play_number(item_info["protection"])

#e.g. sword, spell, breastplate
#use id so I can call from inventory for item pick ups and drops
func play_item_id_sound(var item_id):
	if item_id == null or item_id == "":
		return
	var item_info = db.get_item(item_id)
	if item_info["type"] == "weapon":
		sound_queue.push_front(item_info["sounds"]["swing"])
	if item_info["type"] == "armor":
		sound_queue.push_front(item_info["sounds"]["equip"])
	

# plays audio for a number between 0 and 999 (inclusive)
func play_number(var num):
	var nums = num_to_str_array(num)
	for num in nums:
		 add_sound_to_queue("numbers/" + num)

func num_to_str_array(var num):
	num = int(num)
	if num > 999 or num < 0:
		return [number_overflow]
		#print("number overflow: " + num)
	
	if num == 0:
		return [single_dig_numbers[0]]
	
	var nums_to_play = []
	#separates number into array of digits
	
	while num > 0:
		var n = int(fposmod(num, 10))
		nums_to_play.push_front(n)
		num /= 10
	
	var sound_list = []
	var num_size = nums_to_play.size()
	if num_size == 3:
		sound_list.append(single_dig_numbers[nums_to_play[0]])
		sound_list.append(hundred_number)
		nums_to_play.pop_front()
		num_size -= 1
	
	if num_size == 2:
		if nums_to_play[0] == 1:
			sound_list.append(teen_numbers[nums_to_play[1]])
			return sound_list
		if nums_to_play[0] > 1:
			sound_list.append(double_dig_numbers[nums_to_play[0] - 2])
		nums_to_play.pop_front()
		num_size -= 1
	
	if num_size == 1 and nums_to_play[0] != 0:
		sound_list.append(single_dig_numbers[nums_to_play[0]])
	
	return sound_list

#TODO
func equip_item(var item_id):
	clear_sound_queue()
	play_item_id_sound(item_id)

func unequip_item(var item_id):
	clear_sound_queue()
	play_item_id_sound(item_id)

func drop_item(var item_id):
	clear_sound_queue()
	add_sound_to_queue(drop_sound)