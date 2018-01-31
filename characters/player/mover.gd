extends Node2D

const MOVE_SPEED = 0.5 # meters per second
const STEP_RATE = 0.5 # steps per second
const FOOTSTEPS = ["footstep_1", "footstep_2", "footstep_3"] #footstep sounds

var time_since_last_step = 0

onready var move_ray = $MoveRay #get_node("MoveRay") # collision checking
onready var step_player = $StepPlayer #get_node("StepPlayer")

func _ready():
	pass

# dir_vector: direction to move
# delta: time since last frame
func move_body(var kine_body, var dir_vector, var delta):
	var rot = atan2(dir_vector.x, dir_vector.y)
	var our_rot = global_rotation
	if can_move(rot) && dir_vector.length_squared() > 0:
		time_since_last_step += delta
		attempt_step()
		signal_new_position()
		kine_body.move_and_collide(dir_vector.rotated(our_rot) * MOVE_SPEED)

func can_move(var rot):
	move_ray.rotation = rot
	return !move_ray.is_colliding()

func attempt_step():
	if (time_since_last_step > STEP_RATE):
		time_since_last_step -= STEP_RATE
		var step_index = randi() % FOOTSTEPS.size()
		
		#step_player.play(FOOTSTEPS[step_index])

func signal_new_position():
	get_tree().call_group("doors", "set_player", self)
	get_tree().call_group("enemies", "update_player_pos", global_position)
