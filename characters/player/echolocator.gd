extends Node2D

const PIXELS_PER_METER = 16
const MIN_CLICK_RATE = 0.2 #per second
const MAX_CLICK_RATE = 0.4 
const MAX_DISTANCE = 30 # meters

const MIN_PITCH = 1
const PITCH_DIFF_PER_TIER = 1.5

onready var ping_ray = get_node("RayCast2D")
onready var click_player = get_node("ClickPlayer")

const DIS_PER_TIER = [2, 8, MAX_DISTANCE]

var audio_folder = "res://audio/player/echolocation/"

var click_sounds = ["aa", "ee", "oo"]
var npc_sound = "f"
var enemy_sound = "n"
var loot_sound = "l"
var int_sound = "k"
var alternate = false


var time_since_last_click = 0

func _ready():
	ping_ray.set_cast_to(Vector2(0, MAX_DISTANCE * PIXELS_PER_METER))

# send and play echolocation pings
# delta: time since last frame
func echolocate(var delta):
	var distance = calc_distance()
	var tier = calc_dis_tier(distance)
	var click_rate = calc_click_rate(distance, tier)
	time_since_last_click += delta
	if time_since_last_click >= click_rate:
		time_since_last_click -= click_rate
		play_click(tier)
		tap_hit_obj()

# calculate distance from player to where raycast hits
func calc_distance():
	var distance = -1
	var start_pos = global_position
	var end_point = ping_ray.get_collision_point()
	if (ping_ray.is_colliding()):
		distance = (end_point - start_pos).length()
	if distance < 0:
		return MAX_DISTANCE
	return distance / PIXELS_PER_METER

# calculate the tier of the distance
func calc_dis_tier(var distance):
	var size = DIS_PER_TIER.size()
	var tier = size - 1
	for i in range(size):
		if distance  < DIS_PER_TIER[i]:
			return i
	return tier

# calculate how fast to click
# faster when closer to a lower tier
# slower when closer to a higher tier
func calc_click_rate(var distance, var tier):
	var first_dist = 0
	var sec_dist = DIS_PER_TIER[tier]
	if tier != 0:
		first_dist = DIS_PER_TIER[tier - 1]
	var t = (distance - first_dist) / (sec_dist - first_dist)
	return lerp(MIN_CLICK_RATE, MAX_CLICK_RATE, t)

func play_click(var tier):
	#var pitch = MIN_PITCH + tier * PITCH_DIFF_PER_TIER
	var sound = click_sounds[tier]
	#alternate = !alternate
	if (ping_ray.is_colliding()):
		var hit_obj = ping_ray.get_collider()
		if hit_obj.has_meta("type"):
			var type = hit_obj.get_meta("type")
			var att = ""
			if hit_obj.has_meta("attitude"):
				att = hit_obj.get_meta("attitude")
			if type == "npc" and att == "friendly":
				sound = npc_sound + sound
			elif type == "npc" and att == "hostile":
				sound = enemy_sound + sound
			elif type == "interactable":
				sound = int_sound + sound
			elif type == "loot":
				sound = loot_sound + sound
	click_player.stop()
	var path = audio_folder + sound + ".wav"
	click_player.stream = load(path)
	click_player.play()


# some objects react to being echolocated at, e.g. chimes or gongs
func tap_hit_obj():
	if (ping_ray.is_colliding()):
		var hit_obj = ping_ray.get_collider()
		if hit_obj.has_method("tap"):
			hit_obj.tap()
		#if hit_obj.is_in_group("enemies"):
			#print("enemy")