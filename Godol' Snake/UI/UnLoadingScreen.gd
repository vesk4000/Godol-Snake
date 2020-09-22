extends TextureRect



func _ready():
	Global.quick_tween(self, "rect_position",
			Vector2(0, -600), Vector2(0, 0), 0.25, "restart_game", self, Tween.TRANS_CUBIC, Tween.EASE_OUT)

func restart_game():
	Global.restart()
	get_tree().change_scene("res://Level.tscn")
