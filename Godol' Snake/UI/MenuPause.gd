extends Control


const PauseBackground = preload("res://UI/PauseBackground.tscn")
const MenuHowToPlay = preload("res://UI/MenuHowToPlay.tscn")
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
