extends Area2D
export var load_next_on_use = true

onready var lm = get_node("/root/levelmanager")

func _ready():
	set_meta("type", "interactable")

func use():
	#$AudioStreamPlayer.play()
	if (load_next_on_use):
		lm.load_next_level()
	else:
		lm.load_last_level()
