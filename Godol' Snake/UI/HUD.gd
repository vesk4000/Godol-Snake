extends Control

func _ready():
	Global.quick_tween(get_node("Time"), "anchor_left", -0.5, 0, 0.5)
	Global.quick_tween(get_node("Score"), "anchor_top", -0.5, 0, 0.5)
	Global.quick_tween(get_node("Highscore"), "anchor_left", 1.5, 1, 0.5)
