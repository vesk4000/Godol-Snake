extends TextureRect

var skip_main_menu = false

func _on_Timer_timeout():
	Global.quick_tween(self, "rect_position",
			Vector2(0, 0), Vector2(0, 600), 0.25, "queue_free", self, Tween.TRANS_CUBIC, Tween.EASE_OUT)
