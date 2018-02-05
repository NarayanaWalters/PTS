extends Area2D

onready var sample_player = $AudioStreamPlayer2D

var activated = false
var player = null
var trigger_area
func _ready():
	#sample_player.play("start_text")
	var r = get_node("TriggerArea").get_shape().get_radius()
	var half_extents = Vector2(r, r)
	trigger_area = Rect2(get_global_pos() - half_extents, half_extents * 2)
	set_fixed_process(true)	
	add_to_group("doors")

func _fixed_process(delta):
	if (!activated && player != null && trigger_area.has_point(player.get_global_pos())):
		activated = true
		sample_player.play()


func set_player(var pl):
	player = pl
