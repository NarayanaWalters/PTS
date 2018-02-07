extends Node2D

onready var db = get_node("/root/entity_database")
onready var console = get_node("/root/console")

enum Tab {PAPER_DOLL, BACKPACK, STATS, JOURNAL}
enum PDoll {WEAPON, BACKUP, CHEST}
enum Stats {STR, CON, DEX, INT}

const tabs = ["PAPER_DOLL", "BACKPACK", "STATS", "JOURNAL"]

var cur_tab = 0
var cur_row = 0

var inv = [
# Paper Doll
["w_iron_sword", "", "a_chainmail_vest"],
# Backpack
["w_iron_sword", "w_bronze_dagger", "default_item"],
# Stats
[1101, 2201, 101],
# Journal
["blah", "blah1", "blah2"]
]

func _ready():
	#set_process_input(true)
	#update_text()
	pass

func _input(event):
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
	

func open():
	console.output("inventory opened")
	output_pos()

func close():
	console.output("inventory closed")

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

#drop item from backpack or paper doll
func drop_item():
	if cur_tab == PAPER_DOLL:
		if inv[PAPER_DOLL][cur_row] != "":
			console.output("dropping " + str(inv[PAPER_DOLL][cur_row]))
			inv[PAPER_DOLL][cur_row] = ""
		else:
			console.output("nothing to drop")
	elif cur_tab == BACKPACK:
		if inv[BACKPACK].size() > 0:
			console.output("dropping " + str(inv[BACKPACK][cur_row]))
			inv[BACKPACK].remove(cur_row)
		else:
			console.output("backpack empty")

# equip items from inventory or unequip item from paper doll
func equip_unequip_item():
	if cur_tab == PAPER_DOLL:
		var item = inv[PAPER_DOLL][cur_row]
		if item != "":
			inv[BACKPACK].append(item)
			inv[PAPER_DOLL][cur_row] = ""
			console.output("unequipped " + item)
		else:
			console.output("nothing to unequip")
	elif cur_tab == BACKPACK:
		if inv[BACKPACK].size() > 0:
			inv[PAPER_DOLL][0] = inv[BACKPACK][cur_row]
			console.output("equipped " + inv[BACKPACK][cur_row])
			inv[BACKPACK].remove(cur_row)
		else:
			console.output("nothing to equip")

func insert_into_backpack(var item):
	pass
	#TODO

func output_pos():
	var item_str = "empty"
	if inv[cur_tab].size() > 0:
		item_str = str(inv[cur_tab][cur_row]) 
	
	var txt = "Inventory : "
	txt += str(tabs[cur_tab]) + " : "
	txt += item_str
	console.output(txt)

