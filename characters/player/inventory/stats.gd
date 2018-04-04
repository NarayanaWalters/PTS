extends Node2D

var stats = {
"melee": 1,
"ranged": 1,
"magic": 1
}
var experience = 0
var exp_to_next_level = 6
var level = 1
var skill_points = 1


func level_up():
	skill_points += 1
	experience = 0
	exp_to_next_level = exp_to_next_level / 2 + exp_to_next_level

func spend_skill_point(var stat):
	if stats.has(stat) and skill_points > 0:
		stats[stat] += 1
		skill_points -= 1

func get_stat_value(var stat):
	if stats.has(stat):
		return stats[stat]
	else:
		print("stat doesn't exist: ", stat)
		return 0

