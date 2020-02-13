extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func wrap(var number, var min_value, var max_value):
	if min_value > max_value:
		var _swap = min_value
		min_value = max_value
		max_value = _swap
	
	if number < min_value:
		while(number < min_value):
			number += (max_value - min_value)
	if number > max_value:
		return number % max_value
	return 
