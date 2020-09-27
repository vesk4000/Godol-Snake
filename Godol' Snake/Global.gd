extends Node


var tile_size = 20
var tile_padding = 2
var skip_main_menu = false

var rng = RandomNumberGenerator.new()

onready var SnakeHead = get_node("../Level/Node2D/SnakeHead")

const FlickerNode = preload("res://Flicker.tscn")

var save_path = "user://save.cfg"
var config = ConfigFile.new()
var load_response = config.load(save_path)

var highscore = 0 setget _set_highscore, _get_highscore
func _set_highscore(_highscore):
	highscore = _highscore
	print(load_response)
	print(OK)
	if load_response == OK:
		config.set_value("PlayerData", "Highscore", _highscore)
		config.save(save_path)
func _get_highscore():
	if load_response == OK:
		highscore = config.get_value("PlayerData", "Highscore")
	return highscore

func _ready():
	if load_response == OK:
		if not config.has_section_key("PlayerData", "Highscore"):
			config.set_value("PlayerData", "Highscore", 0)
			config.save(save_path)

func restart():
	SnakeHead = get_node("../Level/Node2D/SnakeHead")

# Globalise screen_width and screen_height
var screen_width = ProjectSettings.get_setting("display/window/size/test_width") \
		setget _set_screen_width, _get_screen_width
func _set_screen_width(var _new_value):
	screen_width = _new_value
	ProjectSettings.set_setting("display/window/size/test_width", _new_value)
	OS.window_size = Vector2(_new_value, OS.window_size.y)
func _get_screen_width():
	return ProjectSettings.get_setting("display/window/size/test_width")
var screen_height = ProjectSettings.get_setting("display/window/size/test_height") \
		setget _set_screen_height, _get_screen_height
func _set_screen_height(var _new_value):
	screen_height = _new_value
	ProjectSettings.set_setting("display/window/size/test_height", _new_value)
	OS.window_size = Vector2(OS.window_size.x, _new_value)
func _get_screen_height():
	return ProjectSettings.get_setting("display/window/size/test_height")

# Globalise base_width and base_height
var base_width = ProjectSettings.get_setting("display/window/size/width") \
		setget _set_base_width, _get_base_width
func _set_base_width(var _new_value):
	base_width = _new_value
	ProjectSettings.set_setting("display/window/size/width", _new_value)
	OS.window_size = Vector2(_new_value, OS.window_size.y)
func _get_base_width():
	return ProjectSettings.get_setting("display/window/size/width")
var base_height = ProjectSettings.get_setting("display/window/size/height") \
		setget _set_base_height, _get_base_height
func _set_base_height(var _new_value):
	base_height = _new_value
	ProjectSettings.set_setting("display/window/size/height", _new_value)
	OS.window_size = Vector2(OS.window_size.x, _new_value)
func _get_base_height():
	return ProjectSettings.get_setting("display/window/size/height")

const MenuPause = preload("res://UI/MenuPause.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("pause") and SnakeHead.game_state == SnakeHead.GameStates.RUNNING:
		SnakeHead.game_state = SnakeHead.GameStates.PAUSED
		var menu_pause = MenuPause.instance()
		get_parent().get_node("Level/GUI").add_child(menu_pause)


func setup_rects(var _self):
	_self.get_node("Rect/MainColorRect").margin_top = tile_padding
	_self.get_node("Rect/MainColorRect").margin_bottom = tile_size - tile_padding
	_self.get_node("Rect/MainColorRect").margin_left = tile_padding
	_self.get_node("Rect/MainColorRect").margin_right = tile_size - tile_padding
	
	_self.get_node("Rect/TopColorRect").set_position(Vector2(tile_padding, 0))
	_self.get_node("Rect/TopColorRect").set_size(Vector2(tile_size - 2 * tile_padding, tile_padding))
	
	_self.get_node("Rect/BottomColorRect").set_position(Vector2(tile_padding, tile_size - tile_padding))
	_self.get_node("Rect/BottomColorRect").set_size(Vector2(tile_size - 2 * tile_padding, tile_padding))
	
	_self.get_node("Rect/LeftColorRect").set_position(Vector2(0, tile_padding))
	_self.get_node("Rect/LeftColorRect").set_size(Vector2(tile_padding, tile_size - 2 * tile_padding))
	
	_self.get_node("Rect/RightColorRect").set_position(Vector2(tile_size - tile_padding, tile_padding))
	_self.get_node("Rect/RightColorRect").set_size(Vector2(tile_padding, tile_size - 2 * tile_padding))


func wrap(var number, var min_value, var max_value):
	if min_value > max_value:
		var _swap = min_value
		min_value = max_value
		max_value = _swap
	
	if number < min_value:
		while(number < min_value):
			number += (max_value - min_value)
	if number >= max_value:
		return fmod(number, max_value)
	return number


func quick_tween(node, variable, start_value, end_value, duration,
		end_function = "", end_function_node = self, trans_type = Tween.TRANS_LINEAR, ease_type = Tween.EASE_IN_OUT):
	node.set(variable, start_value)
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(node, variable, start_value, end_value, duration,
			trans_type, ease_type)
	tween.start()
	if end_function_node == self:
		end_function_node = node
	if end_function != "":
		tween.connect("tween_all_completed", end_function_node, end_function)
	tween.connect("tween_all_completed", tween, "queue_free")


func quick_timer(node, duration, end_function, end_function_node = self):
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(duration)
	if end_function_node == self:
		end_function_node = node
	if end_function != "":
		timer.connect("timeout", end_function_node, end_function)
	timer.connect("timeout", timer, "queue_free")


func quick_flicker(node, wait_time, first_flicker_function,
		second_flicker_function, flicker_function_node = self):
	var flicker = FlickerNode.instance()
	add_child(flicker)
	if flicker_function_node == self:
		flicker_function_node = node
	if first_flicker_function != "":
		flicker.connect("first_flicker", flicker_function_node, first_flicker_function)
	if second_flicker_function != "":
		flicker.connect("second_flicker", flicker_function_node, second_flicker_function)
	flicker.start(wait_time)
	return flicker
