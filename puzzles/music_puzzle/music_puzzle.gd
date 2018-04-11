extends Node2D


export var correct_music_comb = [0, 1, 1]
var cur_music_comb = []

var notes_list = []

signal completed

var solved = false

func _ready():
	for child in get_children():
		child.connect("activated", self, "add_note")

func add_note(id):
	if solved:
		return
	
	cur_music_comb.push_back(id)
	if cur_music_comb.size() > correct_music_comb.size():
		cur_music_comb.pop_front()
	if cur_music_comb == correct_music_comb:
		print ("correct")
		solved = true
		emit_signal("completed")
