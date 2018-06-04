extends Node2D

onready var inv_audio_controller = get_parent().get_node("AudioController")

var stats = {
"melee": 0,
"ranged": 0,
"magic": 0,
"health": 50
}
var experience = 0
var exp_to_next_level = 2
var level = 1
var skill_points = 1

func _ready():
	add_to_group("stats")
	yield(get_tree(), "idle_frame")
	update_max_health()

func spend_skill_point(var stat):
	if stats.has(stat) and skill_points > 0:
		if stat == "health":
			stats[stat] += 10
			update_max_health()
		else:
			stats[stat] += 1
		skill_points -= 1

func get_stat_value(var stat):
	if stats.has(stat):
		return stats[stat]
	else:
		print("stat doesn't exist: ", stat)
		return 0

func update_max_health():
	get_tree().call_group("health", "set_max_health", stats["health"])

func increase_exp(var xp):
	experience += xp
	if experience >= exp_to_next_level:
		level_up()

func level_up():
	inv_audio_controller.play_level_up()
	skill_points += 1
	experience = 0
	exp_to_next_level = exp_to_next_level / 2 + exp_to_next_level
	get_tree().call_group("health", "heal", stats["health"])

func save_to_dict():
	return {
		"stats":stats,
		"experience":experience,
		"exp_to_next_level":exp_to_next_level,
		"level":level,
		"skill_points":skill_points,
	}

func load_from_dict(var dict):
	stats = dict["stats"]
	experience = dict["experience"]
	exp_to_next_level = dict["exp_to_next_level"]
	level = dict["level"]
	skill_points = dict["skill_points"]
	update_max_health()