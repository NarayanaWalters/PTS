extends AudioStreamPlayer
onready var lm = get_node("/root/levelmanager")

func _ready():
	connect("finished", lm, "return_to_main_menu")

