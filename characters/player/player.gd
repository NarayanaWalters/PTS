extends KinematicBody2D

onready var echolocator = get_node("Echolocator")
onready var mover = get_node("Mover")
onready var rotator = get_node("Rotator")
onready var health = get_node("Health")
onready var inventory = get_node("Inventory")
onready var interactor = get_node("Interactor")
onready var combat_manager = get_node("CombatManager")

var max_health = 50

var inventory_open = false

const KEYBOARD_TURN_SPEED = 3
var rot_speed = 0.03
var mouse_sens = 0.1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_meta("type", "player")
	health.set_max_health(max_health)


func _input(ev):
	if ev.is_action_pressed("interact"):
		interactor.attempt_interact()
	
	if ev is InputEventMouseMotion:
		var r = ev.relative.x * mouse_sens
		rotator.rotate_body(self, r, Input.is_action_pressed("align"))

func _process(delta):
	
	if health.is_dead():
		get_tree().reload_current_scene()
		return
	#read out digits of player health
	if Input.is_action_just_pressed("health_read"):
		var hlth_num = health.cur_health
		inventory.get_node("AudioController").play_number(hlth_num)
	
	if inventory_open:
		return
	
	var r = 0
	if (Input.is_action_pressed("turn_right")):
		r += KEYBOARD_TURN_SPEED
	if (Input.is_action_pressed("turn_left")):
		r += -KEYBOARD_TURN_SPEED
	rotator.rotate_body(self, r, Input.is_action_pressed("align"))
	
	if (Input.is_action_pressed("ping")):
		echolocator.echolocate(delta)

	

func _physics_process(delta):
	if inventory_open or health.is_dead():
		return
	
	var move_vec = Vector2(0,0)
	if (Input.is_action_pressed("move_forward")):
		move_vec.y += 1
	if (Input.is_action_pressed("move_backward")):
		move_vec.y += -1
	if (Input.is_action_pressed("move_right")):
		move_vec.x += -1
	if (Input.is_action_pressed("move_left")):
		move_vec.x += 1
	
	mover.move_body(self, move_vec, delta)
	

func deal_damage(var dmg):
	health.damage(dmg)