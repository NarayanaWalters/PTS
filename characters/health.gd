extends Node2D

onready var audio_player = $AudioStreamPlayer2D

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

func set_max_health(var hp):
	max_health = hp
	cur_health = max_health

func damage(var dmg):
	cur_health -= dmg
	play_rnd_sound(hurt_sounds)
	print("took %d dmg at %d hp" % [dmg, cur_health])
	#print (get_parent().name + " took " + str(dmg) + " damage")
	if cur_health <= 0:
		cur_health = 0
		death()

func death():
	play_rnd_sound(death_sounds)
	dead = true

func is_dead():
	return dead

func play_rnd_sound(var list):
	if list.size() <= 0:
		return
	audio_player.stop()
	var index = randi() % list.size()
	audio_player.stream = load(list[index])
	audio_player.play()