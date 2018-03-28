extends Node2D

onready var echolocator = get_parent().get_node("Echolocator")

var rot_speed = 0.1
var rot = 0
#turn slower if pointing at something interesting
var lock_speed = 0.01
#slowly locks to axis if within this rotation
var lock_to_axis_arc = 30
var lock_to_axis_speed = 0.15

var snap_turn_velo = 0
const max_snap_turn_velo = 6

func rotate_body(var body, r_input, align):
	r_input *= rot_speed
	rot += r_input
	if !align:
		snap_turn_velo = 0
		var turn_speed = rot_speed
		if echolocator.looking_at_something:
			turn_speed = lock_speed
		
		body.global_rotation += r_input * turn_speed
		"""
		if !echolocator.looking_at_something and r_input == 0:
			slow_align(body)
		"""
	else:
		snap_turn_velo += r_input
		if abs(snap_turn_velo) >= max_snap_turn_velo:
			snap_turn(body, sign(snap_turn_velo))
		align_to_axis(body)

func snap_turn(var body, var dir):
	body.global_rotation += 90 * sign(dir)
	snap_turn_velo = 0

func slow_align(var body):
	var r = body.global_rotation_degrees
	while r < 0:
		r += 360
	var axises = [0, 90, 180, 270]
	
	# some stuff so I don't have to finagle with the zero axis
	r += lock_to_axis_arc + 2
	r = fposmod(r, 360)
	var r_speed = 0
	for axis in axises:
		axis += lock_to_axis_arc + 2
		if r == axis:
			r_speed = 0
			break
		if r >= axis - lock_to_axis_arc and r < axis:
			r_speed = lock_to_axis_speed
			#print("under arc %f %f" % [axis, r])
			if r + r_speed > axis:
				r_speed = 0
				r = axis
			break
		if r <= axis + lock_to_axis_arc and r > axis:
			r_speed = -lock_to_axis_speed
			#print("over arc %f %f" % [axis, r])
			if r - r_speed < axis:
				r_speed = 0
				r = axis
			break
	
	#if r_speed == 0:
		#print("not in arc %f" % [r])
	r -= lock_to_axis_arc + 2
	r += r_speed
	#print(body.global_rotation_degrees)
	body.global_rotation_degrees = r + r_speed

func align_to_axis(var body):
	var r = body.global_rotation_degrees
	if r < 0:
		r += 360
	var final_r = 0
	if r < 135 && r >= 45:
		final_r = PI / 2
	elif r < 225 && r >= 135:
		final_r = PI
	elif r < 315 && r >= 225:
		final_r = 3*PI/2
	rot = final_r
	body.global_rotation = rot