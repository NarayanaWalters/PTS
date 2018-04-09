extends AudioStreamPlayer

onready var db = get_node("/root/entity_database")
onready var stats_manager = get_parent().get_node("Stats")
const audio_path = "res://audio/inventory/"
const open_sound = "open_inventory"

const tabs_sounds = ["equipment", "backpack", "stats", "journal"]

const close_sound = "close_inventory"
const atk_rate_sound = "description/attack_rate"
var sound_queue = []

const equip_sound = "action/equipped"
const unequip_sound = "action/unequipped"
const drop_sound = "action/dropped"
const pickup_sound = "action/picked_up"

const single_dig_numbers = ["zero", "one", "two", "three", 
"four", "five", "six", "seven", "eight", "nine"]
const teen_numbers = ["ten", "eleven", "twelve", "thirteen",
 "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
const double_dig_numbers = ["twenty", "thirty", "forty", "fifty",
"sixty", "seventy", "eighty", "ninety"]
const number_overflow = "overflow"
const hundred_number = "hundred"

const stats_sounds = {
	"melee": "stats/melee",
	"ranged": "stats/ranged",
	"magic": "stats/magic",
	"health": "stats/health"
}
const experience_snd = "stats/experience"
const skill_pnt_snd = "stats/skill_points"
const out_of_snd = "stats/out_of"
const level_up = "stats/level_up"

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
		play_item_id_sound(item_id)
		if type == "weapon":
			#sound_queue.push_front(item_info["sounds"]["unsheathe"])
			add_sound_to_queue("description/damage")
			play_number(item_info["damage"])
			add_sound_to_queue("description/attack_rate")
			play_number(item_info["attack_rate"])
		elif type == "armor":
			#sound_queue.push_front(item_info["sounds"]["equip"])
			add_sound_to_queue("description/protection")
			play_number(item_info["protection"])

#e.g. sword, spell, breastplate
#use id so I can call from inventory for item pick ups and drops
func play_item_id_sound(var item_id):
	if item_id == null or item_id == "":
		return
	var item_info = db.get_item(item_id)
	sound_queue.push_front(item_info["sounds"]["id"])

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

func equip_item(var item_id, var clear):
	if clear:
		clear_sound_queue()
	add_sound_to_queue(equip_sound)
	play_item_id_sound(item_id)

func unequip_item(var item_id, var clear):
	if clear:
		clear_sound_queue()
	add_sound_to_queue(unequip_sound)
	play_item_id_sound(item_id)

func pickup_items(var item_list):
	clear_sound_queue()
	add_sound_to_queue(pickup_sound)
	for item in item_list:
		play_item_id_sound(item)

func drop_item(var item_id):
	clear_sound_queue()
	add_sound_to_queue(drop_sound)
	play_item_id_sound(item_id)

func play_stat(var stat):
	if stat == "experience":
		add_sound_to_queue(experience_snd)
		play_number(stats_manager.experience)
		add_sound_to_queue(out_of_snd)
		play_number(stats_manager.exp_to_next_level)
	elif stat == "skill_points" and stats_manager.skill_points > 0:
		add_sound_to_queue(skill_pnt_snd)
		play_number(stats_manager.skill_points)
	elif stats_manager.stats.has(stat):
		add_sound_to_queue(stats_sounds[stat])
		play_number(stats_manager.stats[stat])

func play_level_up():
	add_sound_to_queue(level_up)