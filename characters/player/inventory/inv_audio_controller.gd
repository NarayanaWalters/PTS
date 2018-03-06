extends AudioStreamPlayer

onready var db = get_node("/root/entity_database")

var audio_path = "res://audio/inventory/"
var open_sound = "open_inventory"

var tabs_sounds = ["equipment", "backpack", "stats", "journal"]

var close_sound = "close_inventory"
var atk_rate_sound = "swishes2"
var sound_queue = []

var drop_sound = "metal_clash"

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
	


func play_number(var num):
	var nums_to_play = []
	num = int(num)
	if num < 0:
		num = 0
	while num > 0:
		var n = int(fposmod(num, 10))
		nums_to_play.push_front(n)
		num /= 10
	#print(nums_to_play)
	while nums_to_play.size() > 0:
		var snd = "numbers/" + str(nums_to_play.pop_front())
		add_sound_to_queue(snd)

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