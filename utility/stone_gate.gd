extends StaticBody2D

onready var audio_player = $AudioStreamPlayer2D
onready var coll = $CollisionShape2D

func open():
	collision_layer = 0
	coll.disabled = true
	audio_player.play()

func close():
	collision_layer = 1
	coll.disabled = false
	audio_player.play()
