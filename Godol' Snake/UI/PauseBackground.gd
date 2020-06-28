extends ColorRect

func _ready():
	Global.quick_tween(self, "color",
			Color(0, 0, 0, 0), Color(0, 0, 0, 0.5), 0.25)
func close():
	Global.quick_tween(self, "color",
			Color(0, 0, 0, 0.5), Color(0, 0, 0, 0), 0.25, "queue_free")
