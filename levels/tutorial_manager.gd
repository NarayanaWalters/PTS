extends AudioStreamPlayer
#TODO add entries to journal

const audio_path = "res://audio/tutorial/"
var instructions = [
	"heartbeat_and_turning",
	"echo_and_movement",
	"keep_going",
	"cons_and_chests_expl",
	"inventory_expl",
	"fighting_expl",
	"good_luck",
]
#0play heartbeat_expl, 
#1then turning and side right after
#2turn south and play echolocation
#3once echolocated play movement controls
#4once reached end of corridor play keep going audio
#5once turned to face chest play cons and chest expl
#6after opening chest play inventory expl
#7when nearing enemy play combat expl
#8when reached end play good luck
var cur_id = -1

signal add_entry_to_journal(path)

func _ready():
	set_stream(0) #play heartbeat expl

func process_signal(name, param):
	if name == "turned" and param == "south":
		set_stream(1)
	elif name == "reached_loc" and param == "end_of_first_corridor":
		set_stream(2)
	elif name == "turned" and param == "east" and cur_id == 2:
		set_stream(3) 
	elif name == "opened_chest":
		set_stream(4) 
	elif name == "reached_loc" and param == "near_enemy":
		set_stream(5)
	elif name == "reached_loc" and param == "end":
		set_stream(6)

func player_turned(dir): #facing south, play echolocation expl
	process_signal("turned", dir)

func echolocating(dis):
	pass

func reached_loc(spot):
	process_signal("reached_loc", spot)

func opened_chest():
	process_signal("opened_chest", "")

func set_stream(id):
	if cur_id >= id:
		return
	cur_id = id
	var path = audio_path + instructions[id] + ".wav"
	emit_signal("add_entry_to_journal", path)
	stream = load(path)
	play()