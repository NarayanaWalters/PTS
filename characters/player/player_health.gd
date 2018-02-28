extends Node2D

"""
when taking damage, plays the same sfx twice at the same time,
pitches one to be either max or min(0) of hp, depending what cur 
health is closer to. and pitches cur_health relative to that.
"""

onready var audio_player1 = $AudioStreamPlayer
onready var audio_player2 = $AudioStreamPlayer2

const max_hp_pitch = 1.2
const min_hp_pitch = 0.95

var bus_index1 = 0
var bus_index2 = 0

var max_health = 100
var cur_health = max_health
var dead = false
var death_sounds = [
"res://audio/player/injury/die0.wav",
"res://audio/player/injury/die1.wav"]

var hurt_sounds = [
"res://audio/player/injury/pain0.wav",
"res://audio/player/injury/pain1.wav",
"res://audio/player/injury/pain2.wav",
"res://audio/player/injury/pain3.wav"]

func _ready():
	bus_index1 = AudioServer.get_bus_index(audio_player1.bus)
	bus_index2 = AudioServer.get_bus_index(audio_player2.bus)

func set_max_health(var hp):
	max_health = hp
	cur_health = max_health

func damage(var dmg):
	cur_health -= dmg
	play_rnd_sound(hurt_sounds)
	cur_health = clamp(cur_health, 0, max_health)
	
	var pitcher1 = AudioServer.get_bus_effect(bus_index1, 0)
	var pitcher2 = AudioServer.get_bus_effect(bus_index2, 0)
	
	var t = cur_health * 1.0 / max_health
	pitcher1.pitch_scale = lerp(min_hp_pitch, max_hp_pitch, t)
	pitcher2.pitch_scale = max_hp_pitch
	if cur_health < max_health / 2:
		pitcher2.pitch_scale = min_hp_pitch
	
	if cur_health <= 0:
		cur_health = 0
		death()

func death():
	play_rnd_sound(death_sounds)
	dead = true
	if get_parent().has_method("death"):
		get_parent().death()

func is_dead():
	return dead

func play_rnd_sound(var list):
	if list.size() <= 0:
		return
	var index = randi() % list.size()
	audio_player1.stop()
	audio_player1.stream = load(list[index])
	audio_player1.play()
	#audio_player2.stop()
	#audio_player2.stream = load(list[index])
	#audio_player2.play()