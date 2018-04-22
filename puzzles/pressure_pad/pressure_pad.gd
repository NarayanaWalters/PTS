extends Area2D

onready var audio_player = $AudioStreamPlayer2D

export var id = 0
export var sound_on_enter = "res://audio/plate.wav"
export var sound_on_exit = ""

var occupied = false 

signal activated

func _ready():
	connect("body_entered",self,"stepped_on")
	connect("body_exited", self, "stepped_off")

func stepped_on(body):
	if body.get("turning") and body.turning:
		return
	emit_signal("activated", id)
	play_sound(sound_on_enter)

func stepped_off(body):
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

