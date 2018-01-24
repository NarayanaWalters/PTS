extends KinematicBody2D

onready var db = get_node("/root/entity_database")
export var id = ""

#same for everyone
const attack_range = 20
const sight_range = 480

#initialize to default values
var name = "default npc"
var attitude = "friendly"
var move_speed = 2
var attack_rate = 1.0
var base_damage = 30
var inventory = []
var equipped = {}

var player_pos = Vector2(0, 0)
onready var rc = get_node("RayCast2D")
onready var health = get_node("Health")

var time_since_attack = 9999

func _ready():
	set_fixed_process(true)
	init_npc()
	"""
	print(name)
	print(attitude)
	print(move_speed)
	print(attack_rate)
	print(base_damage)
	print(inventory)
	print(equipped)
	"""


func init_npc():
	var npc_data = db.get_npc(id)
	name = npc_data["name"]
	attitude = npc_data["attitude"]
	move_speed = npc_data["move_speed"]
	attack_rate = npc_data["attack_rate"] * 1.0
	base_damage = npc_data["base_damage"]
	health.set_max_health(npc_data["health"])
	
	inventory = npc_data["inventory"]
	equipped = npc_data["equipped"]
	
	if equipped.has("main hand"):
		var weapon = db.get_item(equipped["main hand"])
		base_damage = weapon["damage"]
		attack_rate = weapon["attack_rate"]
		
	
	set_meta("type", "friend")
	if attitude == "hostile":
		add_to_group("enemies")
		set_meta("type", "enemy")

func default_init():
	set_meta("type", "friend")

func _fixed_process(delta):
	seek_and_attack_player(delta)

func seek_and_attack_player(var delta):
	if attitude != "hostile":
		return
	time_since_attack += delta
	if player_is_in_sight_range() and can_see_player():
		if player_is_in_range():
			attack()
		else:
			move_to_player_pos()

func player_is_in_sight_range():
	var pos = get_global_pos()
	var dis = player_pos.distance_squared_to(pos)
	if dis < sight_range * sight_range:
		return true
	return false

func player_is_in_range():
	var pos = get_global_pos()
	var dis = player_pos.distance_squared_to(pos)
	if dis < attack_range * attack_range:
		return true
	return false

func move_to_player_pos():
	var pos = get_global_pos()
	var dir = (player_pos - pos).normalized()
	move(dir * move_speed)

func can_see_player():
	rc.set_cast_to(player_pos - get_global_pos())
	return rc.is_colliding() && rc.get_collider().has_meta("type") && rc.get_collider().get_meta("type") == "player"

func attack():
	if time_since_attack > attack_rate:
		time_since_attack = 0
		if rc.is_colliding() && rc.get_collider().has_method("deal_damage"):
			rc.get_collider().deal_damage(base_damage)
	

func update_player_pos(var p_pos):
	player_pos = p_pos

func deal_damage(var dmg):
	if attitude != "hostile":
		attitude = "hostile"
		add_to_group("enemies")
		set_meta("type", "enemy")
	health.damage(dmg)