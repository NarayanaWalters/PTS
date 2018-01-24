extends Node2D

const MIN_PITCH = 1
const MAX_PITCH_DIFF = 0.5

onready var beat_player = get_node("HeartBeatPlayer")

var beat_voice = 0
var last_r = 0
var was_aligned = false

# [rotation, pan, pitch]
var alignments = [
[0,0,MIN_PITCH], #South
[PI / 2,1, MIN_PITCH + MAX_PITCH_DIFF / 2], #East
[-PI, 0, MIN_PITCH + MAX_PITCH_DIFF], #North
[-PI / 2, -1, MIN_PITCH + MAX_PITCH_DIFF / 2]] #West

func _ready():
	beat_voice = beat_player.play("heartbeat_slow")
	set_process(true)

func _process(delta):
	var rotation = get_global_rot()
	calc_east_west(rotation)
	calc_north_south(rotation)
	# check_play_cross_sound(rotation)
	last_r = rotation


#  1: east
# -1: west
func calc_east_west(var angle):
	var si = sign(angle)
	var diff = abs(abs(angle) - (PI / 2))
	var pan_amnt = si * (1 - diff / (PI / 2))
	beat_player.set_pan(beat_voice, clamp(pan_amnt,-1,1), 0, 0)

#  1: north
#  0: south
func calc_north_south(var angle):
	var pitch_amnt = clamp(1 - (PI - abs(angle)) / PI,0 ,1)
	pitch_amnt = pitch_amnt * MAX_PITCH_DIFF + MIN_PITCH
	beat_player.set_pitch_scale(beat_voice, pitch_amnt)

func check_play_cross_sound(var rotation):
	var aligned = is_aligned(rotation)
	if !aligned && !was_aligned: 
		check_crossed_axis(rotation)
	was_aligned = aligned

func is_aligned(var r):
	for al in alignments:
		if abs(r - al[0]) < 0.01:
			if !was_aligned:
				play_axis_cross(al)
			return true
	return false

func check_crossed_axis(var r):
	var lr = last_r
	var sign_r = sign(r) == -1
	var sign_lr = sign(lr) == -1
	
	var r_greater = abs(r) > PI / 2
	var lr_greater = abs(lr) > PI / 2
	
	if sign_r != sign_lr:
		if r_greater:
			play_axis_cross(alignments[2])
		else:
			play_axis_cross(alignments[0])
	elif r_greater != lr_greater:
		if sign_r:
			play_axis_cross(alignments[3])
		else:
			play_axis_cross(alignments[1])

# axis: [angle, pan, pitch]
func play_axis_cross(var axis):
	var v = beat_player.play("ping")
	beat_player.set_pitch_scale(v, axis[2])
	beat_player.set_pan(v, axis[1], 0, 0)
	#print("a, pan: ", axis[1], " pitch: ", axis[2])
	