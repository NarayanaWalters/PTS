extends RayCast2D
# script that checks how loud to play ambient noise in left or right ear
# based on space in a direction determined by the raycast
const MIN_RANGE = 40

onready var sample_player = get_node("SamplePlayer")

#export var is_left = true
var rang = get_cast_to().y - MIN_RANGE
var voice = 0
func _ready():
	voice = sample_player.play("dungeon_ambient_loop")
	#var pan = -1
	#if is_left:
	#	pan = 1
	#sample_player.set_pan(voice, pan)
	set_process(true)

func _process(delta):
	var distance = rang
	if (is_colliding()):
		var end_point = get_collision_point()
		var start_pos = get_global_pos()
		distance = (end_point - start_pos).length() - MIN_RANGE
	var vol = clamp(distance / rang, 0, 1)
	sample_player.set_volume(voice, vol)
