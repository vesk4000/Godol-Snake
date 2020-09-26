extends Control

const UnLoadingScreen = preload("res://UI/UnLoadingScreen.tscn")
var in_animation = true

func _ready():
	Global.quick_tween($VBoxContainer, "rect_position",
		Vector2(0, -600), Vector2(0, 0), 0.25, "end_animation", self)
	Global.quick_tween($VBoxContainer, "rect_size",
			Vector2(600, 1800), Vector2(600, 600), 0.25)

func end_animation():
	in_animation = false


func _on_Button2_pressed():
	if in_animation:
		return
	in_animation = true
	var unloading_screen = UnLoadingScreen.instance()
	get_parent().add_child(unloading_screen)


func _on_Button3_pressed():
	get_tree().quit()


func _on_Button_pressed():
	if in_animation:
		return
	in_animation = true
	Global.skip_main_menu = true
	var unloading_screen = UnLoadingScreen.instance()
	get_parent().add_child(unloading_screen)
