extends Control

signal start_game

const MenuHowToPlay = preload("res://UI/MenuHowToPlay.tscn");

func _ready():
	Global.quick_tween($VBoxContainer, "rect_position",
			Vector2(0, -600), Vector2(0, 0), 0.25, "")
	Global.quick_tween($VBoxContainer, "rect_size",
			Vector2(600, 1800), Vector2(600, 600), 0.25, "")


func close_menu():
	var menu_how_to_play = MenuHowToPlay.instance()
	get_node("../").add_child(menu_how_to_play)
	queue_free()

func _on_Button_pressed():
	pass

func _on_Button2_pressed():
	Global.quick_tween($VBoxContainer, "rect_position",
			Vector2(0, 0), Vector2(0, -600), 0.25, "close_menu", self)
	Global.quick_tween($VBoxContainer, "rect_size",
			Vector2(600, 600), Vector2(600, 1800), 0.25, "")
