extends Node2D

const level_path = "res://levels/"

var level_list = [
	"tutorial",
	"firststeps",
	"roundabout",
	"first_evil",
	"end"
]
var cur_level = 0

func _ready():
	pass

func load_next_level():
	cur_level += 1
	if cur_level >= level_list.size():
		cur_level = 0
	load_scene_from_name(level_list[cur_level])

func load_last_level():
	cur_level -= 1
	if cur_level < 0:
		cur_level = 0
		return
	load_scene_from_name(level_list[cur_level])

func load_level(var i):
	var name = i
	if typeof(i) == TYPE_INT:
		if i >= 0 and i < level_list.size() - 1:
			name = level_list[i]
	cur_level = level_list.find(name)
	load_scene_from_name(name)

func return_to_main_menu():
	cur_level = -1
	get_tree().change_scene(level_path + "main_menu.tscn")

func format_level_path(var n):
	return level_path + n + ".tscn"

func load_scene_from_name(var n):
	get_tree().call_group("player", "save_char")
	get_tree().change_scene(level_path + n + ".tscn")

func get_cur_scene_name():
	return level_list[cur_level]