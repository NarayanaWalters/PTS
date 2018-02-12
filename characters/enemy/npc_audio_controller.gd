extends AudioStreamPlayer

enum states {IDLE, CHASE}
var state = 0

var idle_sounds = []
var chase_sounds = []
var hurt_sounds = []
var attack_sounds = []

var idle_play_rate = 5.0
var time_since_last_play = 0

func _process(delta):
	time_since_last_play += delta
	if time_since_last_play > idle_play_rate:
		time_since_last_play -= idle_play_rate
		if state == IDLE:
			play_rnd_sound(idle_sounds)
		elif state == CHASE:
			play_rnd_sound(chase_sounds)

func hurt():
	play_rnd_sound(hurt_sounds)

func attack():
	play_rnd_sound(attack_sounds)

func play_rnd_sound(var list):
	if list.size() <= 0:
		return
	var index = randi() % list.size()
	stream = load(list[index])
	time_since_last_play = 0