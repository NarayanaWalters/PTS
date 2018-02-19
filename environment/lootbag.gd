extends Area2D

export var contents = []

func _ready():
	set_meta("type", "loot")

func set_contents(var new_contents):
	contents = new_contents

func pick_up():
	queue_free()
	return contents

func add_item(var item_id):
	contents.push_front(item_id)