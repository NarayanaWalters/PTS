extends AudioStreamPlayer

onready var db = get_node("/root/entity_database")

var audio_path = "res://audio/inventory/"
var open_sound = "open_inventory"
var close_sound = "close_inventory"
var weapon_sound = "metal_clash"
var sound_queue = []

func _ready():
	pass

func _process(delta):
	if sound_queue.size() > 0 and !playing:
		stream = load(sound_queue.pop_back())
		play()

func clear_sound_queue():
	sound_queue.clear()

func add_sound_to_queue(var sound):
	sound_queue.push_front(audio_path + sound + ".wav")

func open():
	clear_sound_queue()
	add_sound_to_queue(open_sound)

func close():
	clear_sound_queue()
	add_sound_to_queue(close_sound)

func play_tab_sound(var tab):
	if tab == 0: #paper_doll
		pass
	elif tab == 1: #backpack
		pass
	elif tab == 2: #stats
		pass
	elif tab == 3: #journal
		pass

# plays id sounds and stats for this item
func play_item_stats(var item_id):
	var item_info = db.get_item(item_id)
	play_item_id_sound(item_id)
	#TODO numbers and item types
	if item_info.has("type") and item_info["type"] == "weapon":
		play_number(item_info["damage"])

#e.g. sword, spell, breastplate
#use id so I can call from inventory for item pick ups and drops
func play_item_id_sound(var item_id):
	if item_id == null:
		return
	var item_info = db.get_item(item_id)
	if item_info["type"] == "weapon":
		pass
	if item_info["type"] == "armor":
		pass
	add_sound_to_queue(weapon_sound)
	


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
	pass

func unequip_item(var item_id):
	pass

func drop_item(var item_id):
	pass