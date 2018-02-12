extends RayCast2D

const DAMAGE = 10
const ATTACK_RATE = 0.2

var last_attack_time = 0

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("attack"):
		attempt_attack()

func attempt_attack():
	var cur_time = OS.get_ticks_msec() / 1000.0
	if cur_time - last_attack_time > ATTACK_RATE:
		print("attack")
		last_attack_time = cur_time
		if is_colliding() && get_collider().has_method("deal_damage"):
			print("k")
			get_collider().deal_damage(DAMAGE)