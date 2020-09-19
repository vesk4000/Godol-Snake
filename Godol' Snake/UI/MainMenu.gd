extends Control

signal start_game

const MenuHowToPlay = preload("res://UI/MenuHowToPlay.tscn")

func _ready():
	Global.quick_tween($VBoxContainer, "rect_position",
		Vector2(0, -600), Vector2(0, 0), 0.25)
	Global.quick_tween($VBoxContainer, "rect_size",
			Vector2(600, 1800), Vector2(600, 600), 0.25)
	if($"../../Node2D/Fruit"):
		connect("start_game", $"../../Node2D/SnakeHead", "_on_MainMenu_start_game")



func _on_Button_pressed():
	Global.quick_tween($VBoxContainer, "rect_position",
			Vector2(0, 0), Vector2(0, -600), 0.25, "start_game", self)
	Global.quick_tween($VBoxContainer, "rect_size",
			Vector2(600, 600), Vector2(600, 1800), 0.25, "")

func start_game():
	emit_signal("start_game")
	queue_free()

func open_how_to_play():
	var menu_how_to_play = MenuHowToPlay.instance()
	get_node("../").add_child(menu_how_to_play)
	queue_free()

func _on_Button2_pressed():
	Global.quick_tween($VBoxContainer, "rect_position",
			Vector2(0, 0), Vector2(0, -600), 0.25, "open_how_to_play", self)
	Global.quick_tween($VBoxContainer, "rect_size",
			Vector2(600, 600), Vector2(600, 1800), 0.25, "")
