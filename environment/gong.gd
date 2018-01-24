extends StaticBody2D

onready var gong_player = get_node("SamplePlayer2D")
signal add_sound

func tap():
	print("bing")
	#gong_player.play
	emit_signal("add_sound")