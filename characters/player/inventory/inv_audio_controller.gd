extends AudioStreamPlayer

onready var db = get_node("/root/entity_database")

var open_sound = "res://audio/inventory/open_inventory.wav"
var close_sound = "res://audio/inventory/close_inventory.wav"
var weapon_sound = "res://audio/inventory/metal_clash.wav"
var sound_queue = []

func _ready():
	pass

func _process(delta):
	if sound_queue.size() > 0 and !playing:
		stream = load(sound_queue.pop_back())
		play()

func open():
	sound_queue.push_front(open_sound)

func close():
	sound_queue.clear()
	sound_queue.push_front(close_sound)

# plays id sounds and stats for this item
func play_item_stats(var item_id):
	#var item_info = db.get_item(item_id)
	play_item_id_sound(item_id)
	#TODO numbers and item types
	

#e.g. sword, spell, breastplate
#use id so I can call from inventory for item pick ups and drops
func play_item_id_sound(var item_id):
	var item_info = db.get_item(item_id)
	if item_info["type"] == "weapon":
		pass
	if item_info["type"] == "armor":
		pass
	sound_queue.push_front(weapon_sound)
	

#TODO
func play_number(var num):
	pass