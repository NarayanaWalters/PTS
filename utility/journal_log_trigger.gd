extends Area2D

onready var tile_map = get_parent().get_node("TileMap")

export var audio_file = ""
export var one_shot = true

func _ready():
	if audio_file != "":
		$AudioStreamPlayer2D.stream = load("res://audio/journal/" + audio_file + ".wav")
	
	if one_shot:
		connect("body_entered", self, "enter_check", [], CONNECT_ONESHOT)
	else:
		connect("body_entered", self, "enter_check")
	pass

func enter_check(obj):
	if obj.has_meta("type") and obj.get_meta("type") == "player":
		$AudioStreamPlayer2D.play()

