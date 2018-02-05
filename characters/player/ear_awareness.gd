extends RayCast2D
# script that checks how loud to play ambient noise in left or right ear
# based on space in a direction determined by the raycast
const MIN_RANGE = 40

onready var sample_player = $AudioStreamPlayer #get_node("SamplePlayer")

#export var is_left = true
var rang = get_cast_to().y - MIN_RANGE
var voice = 0
func _ready():
	pass
	sample_player.play()

func _process(delta):
	var distance = rang
	if (is_colliding()):
		var end_point = get_collision_point()
		var start_pos = global_position
		distance = (end_point - start_pos).length() - MIN_RANGE
	var vol = clamp(distance / rang, 0, 1)
	sample_player.volume_db = lerp(-85, -15, vol)
