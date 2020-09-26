extends Node


signal first_flicker
signal second_flicker

var time : float = 1
var wait_time : float = 1

var flicker = 1


func start(_wait_time = wait_time):
	wait_time = _wait_time
	time = _wait_time
	flicker = 1


func _process(delta):
	time -= delta
	if time <= 0:
		time = wait_time
		if flicker == 1:
			flicker = 2
			emit_signal("second_flicker")
		else:
			flicker = 1
			emit_signal("first_flicker")
