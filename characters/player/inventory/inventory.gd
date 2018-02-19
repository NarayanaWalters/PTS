extends Node2D

onready var db = get_node("/root/entity_database")
onready var console = get_node("/root/console")
onready var audio_controller = $AudioController
onready var interactor = get_parent().get_node("Interactor")

var inv_open = false

enum Tab {PAPER_DOLL, BACKPACK, STATS, JOURNAL}
enum PDoll {WEAPON, BACKUP, CHEST}
enum Stats {STR, CON, DEX, INT}

const tabs = ["PAPER_DOLL", "BACKPACK", "STATS", "JOURNAL"]

var cur_tab = 0
var cur_row = 0

var inv = [
# Paper Doll
["w_iron_sword", "a_chainmail_vest"],
# Backpack
["w_iron_sword", "w_bronze_dagger", "default_item", "a_leather_vest"],
# Stats
[1101, 2201, 101],
# Journal
["blah", "blah1", "blah2"]
]


func _input(event):
	if (Input.is_action_pressed("exit")):
		get_tree().quit()
	if Input.is_action_just_released("open_close_inventory"):
		inv_open = !inv_open
		open(inv_open)
		get_tree().paused = inv_open
	if !inv_open:
		return
	
	if Input.is_action_just_released("move_left"):
		tab_left()
	elif Input.is_action_just_released("move_right"):
		tab_right()
	elif Input.is_action_just_released("move_forward"):
		row_up()
	elif Input.is_action_just_released("move_backward"):
		row_down()
	elif Input.is_action_just_released("turn_left"):
		drop_item()
	elif Input.is_action_just_released("turn_right"):
		equip_unequip_item()
	
# true: open inventory, false: close it
func open(var b):
	if b:
		console.output("inventory opened")
		audio_controller.open()
		output_pos()
	else:
		console.output("inventory closed")
		audio_controller.close()

func tab_left():
	cur_tab = fposmod((cur_tab - 1), Tab.size())
	cur_row = 0
	output_pos()

func tab_right():
	cur_tab = fposmod((cur_tab + 1), Tab.size())
	cur_row = 0
	output_pos()

func row_up():
	cur_row -= 1
	clamp_row()
	output_pos()

func row_down():
	cur_row += 1
	clamp_row()
	output_pos()

func clamp_row():
	var orig_pos = cur_row
	var siz = inv[cur_tab].size()
	if cur_row < 0:
		cur_row += siz
	elif siz > 0:
		cur_row = fposmod(cur_row, siz)
	else:
		cur_row = 0

func get_current_slot_contents():
	if inv[cur_tab].size() > 0:
		return inv[cur_tab][cur_row]
	else:
		return null

#drop item from backpack or paper doll
func drop_item():
	if cur_tab != PAPER_DOLL and cur_tab != BACKPACK:
		return
	
	if inv[cur_tab].size() > 0:
		console.output("dropping " + str(inv[cur_tab][cur_row]))
		audio_controller.drop_item(inv[cur_tab][cur_row])
		interactor.drop_item(inv[cur_tab][cur_row])
		inv[cur_tab].remove(cur_row)
		clamp_row()
	else:
		console.output("nothing to drop")

# equip items from inventory or unequip item from paper doll
func equip_unequip_item():
	if cur_tab == PAPER_DOLL:
		audio_controller.equip_item(get_current_slot_contents())
		unequip_from_p_doll()
	elif cur_tab == BACKPACK:
		audio_controller.unequip_item(get_current_slot_contents())
		equip_from_backpack()

func unequip_from_p_doll():
	if inv[PAPER_DOLL].size() == 0:
		return
	var item = inv[PAPER_DOLL][cur_row]
	if item != "":
		inv[BACKPACK].push_front(item)
		inv[PAPER_DOLL].remove(cur_row)
		console.output("unequipped " + item)
	else:
		console.output("nothing to unequip")

# equip item at current ro win backpack to paper doll
# if something is already equipped to the same slot 
# unequip that item and replace it
func equip_from_backpack():
	if inv[BACKPACK].size() > 0:
		var item_id = inv[BACKPACK][cur_row]
		var item_to_eq = db.get_item(item_id)
		var type = item_to_eq["type"]
		var slot = ""
		if item_to_eq.has("slot"):
			slot = item_to_eq["slot"]
			var outp = ""
			for item in inv[PAPER_DOLL]:
				var cur_item = db.get_item(item)
				if cur_item["type"] == type and cur_item["slot"] == slot:
					inv[PAPER_DOLL].erase(item)
					inv[BACKPACK].push_front(item)
					row_down()
					outp = "unequipped " + item + " : "
					break
			inv[PAPER_DOLL].push_front(item_id)
			inv[BACKPACK].remove(cur_row)
			console.output(outp + "equipped " + item_id)
			
		else:
			console.output("cannot equip this")
	else:
		console.output("nothing to equip")

func pickup_items(var items_list):
	#print(inv[BACKPACK])
	for item in items_list:
		#print("adding: " + item)
		inv[BACKPACK].push_front(item)
	#print("current contents are now : " + str(inv[BACKPACK]))

func insert_into_backpack(var item_id):
	inv[BACKPACK].push_front(item_id)

func output_pos():
	audio_controller.clear_sound_queue()
	audio_controller.play_tab_sound(cur_tab)
	if cur_tab == BACKPACK or cur_tab == PAPER_DOLL:
		audio_controller.play_item_stats(get_current_slot_contents())
	
	var item_str = "empty"
	if inv[cur_tab].size() > 0:
		item_str = str(inv[cur_tab][cur_row]) 
	
	var txt = "Inventory : "
	txt += str(tabs[cur_tab]) + " : "
	txt += item_str
	console.output(txt)

#for tests
func clear():
	inv[BACKPACK] = []
	inv[PAPER_DOLL] = []

func get_contents_of_backpack():
	return inv[BACKPACK]

func get_contents_of_p_doll():
	return inv[PAPER_DOLL]