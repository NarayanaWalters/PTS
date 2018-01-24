extends SamplePlayer2D

const SOUND_PLAY_RATE = 0.4
var time_since_last_played = 0
var cur_sound_to_play = 0
onready var sound_player = get_node("SamplePlayer2D")

export var sound_key = [0,1,0]
var cur_key = []
var opened = false
signal open_door

func _ready():
	set_process(true)

func _process(delta):
	time_since_last_played += delta
	if time_since_last_played > SOUND_PLAY_RATE:
		time_since_last_played -= SOUND_PLAY_RATE
		cur_sound_to_play += 1
		cur_sound_to_play %= sound_key.size()
		sound_player.stop_all()
		sound_player.play("Test")
		#voice_set_pitch_scale(v, sound_key[cur_sound_to_play] + 1)

func add_sound(var s):
	print(s)
	cur_key.push_front(s)
	while cur_key.size() > sound_key.size():
		cur_key.pop_back()
	if cur_key.size() != sound_key.size():
		return
	for i in range(sound_key.size()):
		if cur_key[i] != sound_key[i]:
			return
	if opened:
		return
	open_door()

func open_door():
	print("open")
	emit_signal("open_door")
	pass
