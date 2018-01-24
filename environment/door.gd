extends StaticBody2D

onready var sample_player = get_node("SamplePlayer2D")

func open_door():
	print("opening")
	#sample_player.play
	set_collision_mask(0)
	set_layer_mask(0)
