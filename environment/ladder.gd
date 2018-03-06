extends Area2D

func _ready():
	set_meta("type", "interactable")

func use():
	$AudioStreamPlayer.play()
