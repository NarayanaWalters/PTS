extends Node2D

const level_path = "res://levels/"

var level_list = [
	"tutorial",
	"firststeps",
	"firstevil"
]
var cur_level = 0

func _ready():
	pass

func load_next_level():
	cur_level += 1
	if cur_level >= level_list.size():
		cur_level = 0
	get_tree().change_scene(format_level_path(level_list[cur_level]))

func load_last_level():
	cur_level -= 1
	if cur_level < 0:
		cur_level = 0
		return
	get_tree().change_scene(format_level_path(level_list[cur_level]))

func load_level(var i):
	if typeof(i) == TYPE_INT:
		if i >= 0 and i < level_list.size() - 1:
			get_tree().change_scene(format_level_path(level_list[i]))
	else:
		get_tree().change_scene(format_level_path(i))

func format_level_path(var n):
	return level_path + n + ".tscn"