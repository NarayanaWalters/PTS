extends Node2D

export var max_health = 100
var cur_health = max_health
var dead = false

func set_max_health(var hp):
	max_health = hp
	cur_health = max_health

func damage(var dmg):
	cur_health -= dmg
	print (get_parent().name + " took " + str(dmg) + " damage")
	if cur_health < 0:
		cur_health = 0
		death()

func death():
	print ("dead")
	dead = true

func is_dead():
	return dead