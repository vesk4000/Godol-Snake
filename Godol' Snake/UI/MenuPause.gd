extends Control


const PauseBackground = preload("res://UI/PauseBackground.tscn")
const MenuHowToPlay = preload("res://UI/MenuHowToPlay.tscn")
const UnLoadingScreen = preload("res://UI/UnLoadingScreen.tscn")
const MenuSettings = preload("res://UI/MenuSettings.tscn")
var pause_background
var in_animation = false
var run_after_close

func _ready():
	in_animation = true
	Global.quick_tween($VBoxContainer, "rect_position",
		Vector2(0, -600), Vector2(0, 0), 0.25, "end_animation", self)
	Global.quick_tween($VBoxContainer, "rect_size",
			Vector2(600, 1800), Vector2(600, 600), 0.25)
	pause_background = PauseBackground.instance()
	get_parent().add_child(pause_background)
	get_parent().move_child(pause_background, self.get_index() - 1)

func close(_run_after_close = ""):
	if in_animation:
		return
	in_animation = true
	run_after_close = _run_after_close
	pause_background.close()
	Global.quick_tween($VBoxContainer, "rect_position",
			Vector2(0, 0), Vector2(0, -600), 0.25, "close_final", self)
	Global.quick_tween($VBoxContainer, "rect_size",
			Vector2(600, 600), Vector2(600, 1800), 0.25)

func close_final():
	call(run_after_close)
	queue_free()

func end_animation():
	in_animation = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		close("return_to_game_final")

func return_to_game_final():
	Global.SnakeHead.game_state = Global.SnakeHead.GameStates.RUNNING

func _on_Button_pressed():
	close("return_to_game_final")


func _on_Button2_pressed():
	close("open_how_to_play")

func open_how_to_play():
	var menu_how_to_play = MenuHowToPlay.instance()
	menu_how_to_play.last_menu_path = filename
	get_node("../").add_child(menu_how_to_play)


func _on_Button6_pressed():
	get_tree().quit()


func _on_Button5_pressed():
	if in_animation:
		return
	in_animation = true
#	OS.execute(OS.get_executable_path(), [], false)
#	get_tree().quit()
#	Global.restart()
#	get_tree().change_scene("res://Level.tscn")
	var unloading_screen = UnLoadingScreen.instance()
	get_parent().add_child(unloading_screen)


func _on_Button7_pressed():
	if in_animation:
		return
	in_animation = true
	Global.skip_main_menu = true
	var unloading_screen = UnLoadingScreen.instance()
	get_parent().add_child(unloading_screen)


func _on_Button3_pressed():
	close("open_settings")

func open_settings():
	var menu_settings = MenuSettings.instance()
	menu_settings.last_menu_path = filename
	get_node("../").add_child(menu_settings)
