extends AudioStreamPlayer2D

export var one_shot = true
export var play_on_start = false
var dont_play = false
func _ready():
	# cant set position directly so make a child
	# so I don't need to put path in direcly
	$AudioStreamPlayer.stream = stream
	if play_on_start:
		$AudioStreamPlayer.play()
		return
	
	if one_shot:
		$Area2D.connect("body_entered", self, "enter_check", [], CONNECT_ONESHOT)
	else:
		$Area2D.connect("body_entered", self, "enter_check")
	pass

func enter_check(obj):
	if dont_play:
		return
	if obj.has_meta("type") and obj.get_meta("type") == "player":
		$AudioStreamPlayer.play()

func dont_play():
	dont_play = true
