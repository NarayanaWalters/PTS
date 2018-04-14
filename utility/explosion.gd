extends Area2D
var pixels_per_meter = 8 #halved because radius not diameter

func init_expl(var dmg, var rad, var pos):
	global_position = pos
	$CollisionShape2D.shape.radius = rad * pixels_per_meter
	detonate(dmg)

func detonate(var dmg):
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	
	var bodies = get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		if body.has_method("deal_damage"):
			body.deal_damage(dmg)
	queue_free()
