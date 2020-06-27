extends Control


func _ready():
	Global.quick_tween(self, "rect_position",
			Vector2(-600, 0), Vector2(0, 0), 0.25, "")

func _on_Button_pressed():
	Global.quick_tween(self, "rect_position",
			Vector2(0, 0), Vector2(-600, 0), 0.25, "close_menu")

func close_menu():
	var MainMenu = load("res://UI/MainMenu.tscn")
	var main_menu = MainMenu.instance()
	get_parent().add_child(main_menu)
	queue_free()
