extends KinematicBody2D

onready var db = get_node("/root/entity_database")
export var id = ""

#same for everyone
const attack_range = 20
const sight_range = 480

#initialize to default values
var npc_name = "default npc"
var attitude = "friendly"
var move_speed = 2
var attack_rate = 1.0
var base_damage = 30
var inventory = []
var equipped = {}
var xp = 1


var player_pos = Vector2(0, 0)
onready var rc = get_node("RayCast2D")
onready var health = get_node("Health")
onready var audio_controller = $NPCAudioController

var time_since_attack = 9999

var saw_player = false

var last_saw_player = null

func _ready():
	init_npc()
	set_meta("attitude", attitude)
	set_meta("type", "npc")


func init_npc():
	var npc_data = db.get_npc(id)
	if npc_data.has("sounds"):
		audio_controller.init_sounds(npc_data["sounds"])
		#TODO
		health.death_sounds = []
		health.hurt_sounds = []
	npc_name = npc_data["name"]
	attitude = npc_data["attitude"]
	move_speed = npc_data["move_speed"]
	attack_rate = npc_data["attack_rate"] * 1.0
	base_damage = npc_data["base_damage"]
	health.set_max_health(npc_data["health"])
	if npc_data.has("xp"):
		xp = npc_data["xp"]
	inventory = npc_data["inventory"]
	equipped = npc_data["equipped"]
	
	if equipped.has("main hand"):
		var weapon = db.get_item(equipped["main hand"])
		base_damage = weapon["damage"]
		attack_rate = weapon["attack_rate"]
	
	if attitude == "hostile":
		add_to_group("enemies")

func _process(delta):
	audio_controller.muffle(can_see_player())


func _physics_process(delta):
	if attitude == "hostile":
		seek_and_attack_player(delta)
		time_since_attack += delta

func seek_and_attack_player(var delta):
	if player_is_in_sight_range() and can_see_player():
		if !saw_player:
			saw_player = true
			audio_controller.state = 1
			audio_controller.alert()
		if player_is_in_range():
			attack()
		else:
			move_to_pos(player_pos, delta)
	if !can_see_player() and last_saw_player != null:
		move_to_pos(last_saw_player, delta)

func player_is_in_sight_range():
	var pos = global_position
	var dis = player_pos.distance_squared_to(pos)
	if dis < sight_range * sight_range:
		return true
	return false

func player_is_in_range():
	var pos = global_position
	var dis = player_pos.distance_squared_to(pos)
	if dis < attack_range * attack_range:
		return true
	return false

func move_to_pos(var p_pos, var delta):
	var pos = global_position
	var dir = (p_pos - pos).normalized()
	move_and_collide(dir * move_speed * delta)

func can_see_player():
	rc.set_cast_to(player_pos - global_position)
	var se = rc.is_colliding() and rc.get_collider() != null and rc.get_collider().has_meta("type") and rc.get_collider().get_meta("type") == "player"
	if se:
		last_saw_player = player_pos
	return se

func attack():
	if time_since_attack > attack_rate:
		time_since_attack = 0
		audio_controller.attack()
		if rc.is_colliding() and rc.get_collider().has_method("deal_damage"):
			rc.get_collider().deal_damage(base_damage)
	

func update_player_pos(var p_pos):
	player_pos = p_pos

func deal_damage(var dmg):
	audio_controller.hurt()
	if attitude != "hostile":
		attitude = "hostile"
		add_to_group("enemies")
		set_meta("attitude", attitude)
	health.damage(dmg)

func death():
	get_tree().call_group("stats", "increase_exp", xp)
	queue_free()