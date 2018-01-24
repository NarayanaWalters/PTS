extends Area2D

export var contents = []

func _ready():
	pass

func set_contents(var new_contents):
	contents = new_contents

func pick_up():
	#destroy
	return contents
