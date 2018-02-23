extends Node2D

const MOVE_SPEED = 1 # meters per second
const STEP_RATE = 0.5 # steps per second
const FOOTSTEPS = ["footstep_1", "footstep_2", "footstep_3"] #footstep sounds

var audio_folder = "res://characters/player/player_audio/"

var time_since_last_step = 0

onready var move_ray = $MoveRay #get_node("MoveRay") # collision checking
onready var step_player = $StepPlayer #get_node("StepPlayer")

func _ready():
	pass

#var line = [Vector2(), Vector2()]
#func _draw():
#	draw_line(line[0], line[1] * 100, Color(1, 1, 1), 2)

# dir_vector: direction to move
# delta: time since last frame
func move_body(var kine_body, var dir_vector, var delta):
	var rot = atan2(dir_vector.x, dir_vector.y)
	var our_rot = global_rotation
	
	#line[1] = move_ray.get_cast_to().rotated(rot * -1) # for debug purposes
	#update()
	
	if can_move(rot) && dir_vector.length_squared() > 0:
		time_since_last_step += delta
		attempt_step()
		signal_new_position()
		kine_body.move_and_collide(dir_vector.rotated(our_rot) * MOVE_SPEED)
	#else:
	#	bump_away_from_walls(kine_body)

func bump_away_from_walls(var body):
	if move_ray.is_colliding():
		var norm = move_ray.get_collision_normal()
		print(norm)
		body.move_and_collide(norm)

func can_move(var rot):
	move_ray.rotation = rot * -1
	return !move_ray.is_colliding()

func attempt_step():
	if (time_since_last_step > STEP_RATE):
		time_since_last_step -= STEP_RATE
		var step_index = randi() % FOOTSTEPS.size()
		var sample = load(audio_folder + FOOTSTEPS[step_index] + ".wav")
		step_player.stream = sample
		step_player.play()

func signal_new_position():
	get_tree().call_group("doors", "set_player", self)
	get_tree().call_group("enemies", "update_player_pos", global_position)
