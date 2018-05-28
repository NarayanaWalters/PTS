extends Area2D

signal player_entered(spot)

export var spot = "emp"

func _ready():
	connect("body_entered", self, "enter_check")
	pass

func enter_check(obj):
	if obj.has_meta("type") and obj.get_meta("type") == "player":
		emit_signal("player_entered", spot)
