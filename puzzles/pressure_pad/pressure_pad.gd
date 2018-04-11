extends Area2D

onready var audio_player = $AudioStreamPlayer2D

export var id = 0
export var sound_on_enter = ""
export var sound_on_exit = ""

signal activated

func _ready():
	connect("body_entered",self,"stepped_on")
	connect("body_exited", self, "stepped_off")

func stepped_on(body):
	#print("enter",body)
	emit_signal("activated", id)
	play_sound(sound_on_enter)

func stepped_off(body):
	#print("exit",body)
	play_sound(sound_on_exit)

func play_sound(var snd):
	if snd == "":
		return
	if !File.new().file_exists(snd):
		return
	
	var strm = load(snd)
	if strm == null:
		return
	audio_player.stream = strm
	audio_player.play()

