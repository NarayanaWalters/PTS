extends Area2D
#script controls interacting with objects in the world,
# e.g. levers and lootbags, also dropping items into loot bags
onready var inventory = get_parent().get_node("Inventory")
var lootbag_scene = ""

#TODO raycast to nearby objects before interact, or just make 
# interact radius smaller than walls

func attempt_interact():
	var nearby_objects = get_overlapping_areas()
	if nearby_objects.size() == 0:
		return
	var nearest_interactable_obj = nearby_objects[0]
	
	var pos = get_global_pos()
	var min_dist = 99999
	for object in nearby_objects:
		var obj_pos = object.get_global_pos()
		var dis = pos.distance_squared_to(obj_pos)
		if dis < min_dist:
			nearest_interactable_obj = object

	if nearest_interactable_obj.has_method("pick_up"):
		print(nearest_interactable_obj.pick_up())

func drop_item(var item_id):
	pass

func get_nearest_object():
	pass
