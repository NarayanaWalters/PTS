extends KinematicBody2D

onready var echolocator = get_node("Echolocator")
onready var mover = get_node("Mover")
onready var rotator = get_node("Rotator")
onready var health = get_node("Health")
onready var inventory = get_node("Inventory")
onready var interactor = get_node("Interactor")
onready var combat_manager = get_node("CombatManager")

var inventory_open = false

var rot_speed = 0.03
var rotation = 0
var mouse_sens = 0.1

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_meta("type", "player")
	set_process_input(true)
	set_process(true)
	set_fixed_process(true)

func _input(event):
	if event.is_action_pressed("open_close_inventory"):
		inventory_open = !inventory_open
		if inventory_open:
			inventory.show()
		else:
			inventory.hide()
		inventory.set_process_input(inventory_open)
		combat_manager.set_process_input(!inventory_open)
	
	if inventory_open:
		return
	
	if event.is_action_pressed("interact"):
		interactor.attempt_interact()
	if event.type == InputEvent.MOUSE_MOTION:
		var r = event.relative_x * mouse_sens * -1
		rotator.rotate_body(self, r, Input.is_action_pressed("align"))

func _process(delta):
	if inventory_open:
		return
	
	var r = 0
	if (Input.is_action_pressed("turn_right")):
		r += -1
	if (Input.is_action_pressed("turn_left")):
		r += 1
	rotator.rotate_body(self, r, Input.is_action_pressed("align"))
	
	if (Input.is_action_pressed("ping")):
		echolocator.echolocate(delta)
	if (Input.is_action_pressed("exit")):
		get_tree().quit()
	

func _fixed_process(delta):
	if inventory_open:
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