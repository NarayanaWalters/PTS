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
	var update_console = true
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
	else:
		update_console = false
	
	if inv[cur_tab].size() > 0:
		cur_row %= inv[cur_tab].size()
	else:
		cur_row = 0
	
	
	var txt = "Inventory : "
	txt += str(tabs[cur_tab]) + " : "
	txt += get_current_item_str() + " : "
	if update_console:
		console.output(txt)


func tab_left():
	cur_tab = (cur_tab - 1) % Tab.size()
	cur_row = 0

func tab_right():
	cur_tab = (cur_tab + 1) % Tab.size()
	cur_row = 0

func row_up():
	cur_row -= 1

func row_down():
	cur_row += 1

func get_current_item_str():
	if inv[cur_tab].size() > 0:
		return str(inv[cur_tab][cur_row]) 
	else:
		return "empty"

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
	if cur_tab == PAPER_DOLL && inv[PAPER_DOLL][cur_row] != "":
		inv[BACKPACK].append(inv[PAPER_DOLL][cur_row])
		inv[PAPER_DOLL][cur_row] = ""
	elif cur_tab == BACKPACK && inv[BACKPACK].size() > 0:
		inv[PAPER_DOLL][0] = inv[BACKPACK][cur_row]
		inv[BACKPACK].remove(cur_row)

func update_text():
	var txt = "" + "PAPER_DOLL, BACKPACK, STATS, JOURNAL" + "\n"
	txt += "Tab: " + str(tabs[cur_tab]) + "\n"
	if inv[cur_tab].size() > 0:
		txt += "Row: " + str(inv[cur_tab][cur_row]) + "\n"
	txt += "Paper Doll: " + str(inv[PAPER_DOLL]) + "\n"
	txt += "BackPack: " + str(inv[BACKPACK]) + "\n"
	txt += "Stats: " + str(inv[STATS]) + "\n"
	txt += "Journal: " + str(inv[JOURNAL]) + "\n"
	set_text(txt)
