extends Control

signal start_game

const MenuHowToPlay = preload("res://UI/MenuHowToPlay.tscn")
const MenuSettings = preload("res://UI/MenuSettings.tscn")
var in_animation = false
var run_after_close

func _ready():
	if Global.skip_main_menu:
		visible = false
		return
	Global.quick_tween($VBoxContainer, "rect_position",
		Vector2(0, -600), Vector2(0, 0), 0.25)
	Global.quick_tween($VBoxContainer, "rect_size",
			Vector2(600, 1800), Vector2(600, 600), 0.25)
	if($"../../Node2D/SnakeHead"):
		connect("start_game", $"../../Node2D/SnakeHead", "_on_MainMenu_start_game")

func _process(delta):
	if Global.skip_main_menu and not get_node_or_null("../LoadingScreen"):
		Global.skip_main_menu = false
		if($"../../Node2D/SnakeHead"):
			connect("start_game", $"../../Node2D/SnakeHead", "_on_MainMenu_start_game")
#		call_deferred("emit_signal", "start_game")
#		call_deferred("queue_free")
		emit_signal("start_game")
		queue_free()

func close(_run_after_close = ""):
	if in_animation:
		return
	in_animation = true
	run_after_close = _run_after_close
	Global.quick_tween($VBoxContainer, "rect_position",
			Vector2(0, 0), Vector2(0, -600), 0.25, "close_final", self)
	Global.quick_tween($VBoxContainer, "rect_size",
			Vector2(600, 600), Vector2(600, 1800), 0.25)

func close_final():
	call(run_after_close)
	queue_free()

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
	menu_how_to_play.last_menu_path = filename
	get_node("../").add_child(menu_how_to_play)

func _on_Button2_pressed():
	close("open_how_to_play")


func _on_Button3_pressed():
	get_tree().quit()


func _on_Button4_pressed():
	close("open_settings")

func open_settings():
	var menu_settings = MenuSettings.instance()
	menu_settings.last_menu_path = filename
	get_node("../").add_child(menu_settings)
