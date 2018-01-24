extends Area2D

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
