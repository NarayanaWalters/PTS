extends Node2D

onready var inv_audio_controller = get_parent().get_node("AudioController")

var stats = {
"melee": 0,
"ranged": 0,
"magic": 0
}
var experience = 0
var exp_to_next_level = 2
var level = 1
var skill_points = 0

func _ready():
	add_to_group("stats")

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

func increase_exp(var xp):
	experience += xp
	if experience >= exp_to_next_level:
		level_up()

func level_up():
	inv_audio_controller.play_level_up()
	skill_points += 1
	experience = 0
	exp_to_next_level = exp_to_next_level / 2 + exp_to_next_level
