extends Area2D
var pixels_per_meter = 8 #halved because radius not diameter

func init_expl(var dmg, var rad, var pos):
	global_position = pos
	$CollisionShape2D.shape.radius = rad * pixels_per_meter
	yield(get_tree(), "idle_frame")
	detonate(dmg)

func detonate(var dmg):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.has_method("deal_damage"):
			body.deal_damage(dmg)
	queue_free()
