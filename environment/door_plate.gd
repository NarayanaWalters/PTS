extends StaticBody2D

onready var door = get_node("Door")
onready var plate = get_node("Plate")
onready var sound_player = $AudioStreamPlayer2D

export var start_closed = false
var closed = false
var player = null
var trigger_area

var start_msk
var start_lay
func _ready():
	start_msk = get_collision_mask()
	start_lay = get_layer_mask()
	closed = start_closed
	update_door()
	add_to_group("doors")
	var r = plate.get_node("TriggerArea").get_shape().get_radius()
	var half_extents = Vector2(r, r)
	trigger_area = Rect2(plate.get_global_pos() - half_extents, half_extents * 2)
	set_fixed_process(true)

func close():
	closed = true
	set_collision_mask(start_msk)
	set_layer_mask(start_lay)
	#sound_player.play("close")
	sound_player.play()

func open():
	closed = false
	set_collision_mask(0)
	set_layer_mask(0)
	#sound_player.play("open")
	#sound_player.play("Slam")

func _fixed_process(delta):
	if (player != null && closed == start_closed && trigger_area.has_point(player.get_global_pos())):
		closed = !start_closed
		update_door()

func update_door():
	if (closed):
		close()
	else:
		open()

func set_player(var pl):
	player = pl