extends Control

const PauseBackground = preload("res://UI/PauseBackground.tscn")
var pause_background


func _ready():
	pause_background = PauseBackground.instance()
	get_parent().add_child(pause_background)
	get_parent().move_child(pause_background, self.get_index() - 1)
	Global.quick_tween(self, "rect_position",
			Vector2(-600, 0), Vector2(0, 0), 0.25)

func _on_Button_pressed():
	Global.quick_tween(self, "rect_position",
			Vector2(0, 0), Vector2(-600, 0), 0.25, "close_menu")
	pause_background.close()

func close_menu():
	var MainMenu = load("res://UI/MainMenu.tscn")
	var main_menu = MainMenu.instance()
	get_parent().add_child(main_menu)
	main_menu.get_node("VBoxContainer/CenterContainer2/VBoxContainer/Button2").grab_focus()
	queue_free()
