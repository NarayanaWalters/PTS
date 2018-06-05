extends Node2D

onready var lm = get_node("/root/levelmanager")
const SAVE_PATH = "user://savegame.save"

func _ready():
	
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_1:
			new_game()
		if event.scancode == KEY_2:
			load_game()
		if event.scancode == KEY_ESCAPE:
			exit()

func new_game():
	var save_game = File.new()
	if save_game.file_exists(SAVE_PATH):
		var dir = Directory.new()
		dir.remove(SAVE_PATH)
		#save_game.remove(SAVE_PATH)
		pass
	lm.load_level(0)

func load_game():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		lm.load_level(0)
		return
	
	save_game.open(SAVE_PATH, File.READ)
	var lvl = save_game.get_line()
	lm.load_level(lvl)
	save_game.close()

func exit():
	get_tree().quit()