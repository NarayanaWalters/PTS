extends RayCast2D

onready var audio_player = $AudioStreamPlayer

var fist_dmg = 10
var fist_speed = 0.4
var fist_hit_snd = "res://audio/weapons/punch.wav"
var fist_swing_snd = "res://audio/weapons/punch.wav"

var damage = fist_dmg
var atk_rate = fist_speed

var prep_sound = ""
var atk_sound = fist_swing_snd
var atk_hit_sound = fist_hit_snd

var time_since_atk = 0

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("attack"):
		attempt_attack()

func unequip_wep():
	damage = fist_dmg
	atk_rate = fist_speed
	prep_sound = ""
	atk_sound = fist_swing_snd
	atk_hit_sound = fist_hit_snd

#pass dictionary from database
func equip_wep(var item_to_eq):
	damage = item_to_eq["damage"]
	atk_rate = item_to_eq["attack_rate"] / 10.0
	atk_sound = item_to_eq["sounds"]["atk_swing_sound"]
	atk_hit_sound = item_to_eq["sounds"]["atk_hit_sound"]
	prep_sound = item_to_eq["sounds"]["prep_sound"]

func _process(delta):
	time_since_atk += delta
	if prep_sound != "":
		pass


func attempt_attack():
	if time_since_atk >= atk_rate:
		time_since_atk = 0
		var snd_to_play = atk_sound
		if is_colliding() && get_collider().has_method("deal_damage"):
			get_collider().deal_damage(damage)
			snd_to_play = atk_hit_sound
		audio_player.stream = load(snd_to_play)
		audio_player.play()