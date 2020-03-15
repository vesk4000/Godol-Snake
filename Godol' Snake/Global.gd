extends Node


var tile_size = 20
var tile_padding = 2

var rng = RandomNumberGenerator.new()

# Globalise screen_width and screen_height
var screen_width = ProjectSettings.get_setting("display/window/size/width") \
		setget _set_screen_width, _get_screen_width
func _set_screen_width(var _new_value):
	screen_width = _new_value
	ProjectSettings.set_setting("display/window/size/width", _new_value)
	OS.window_size = Vector2(_new_value, OS.window_size.y)
func _get_screen_width():
	return ProjectSettings.get_setting("display/window/size/width")
var screen_height = ProjectSettings.get_setting("display/window/size/height") \
		setget _set_screen_height, _get_screen_height
func _set_screen_height(var _new_value):
	screen_height = _new_value
	ProjectSettings.set_setting("display/window/size/height", _new_value)
	OS.window_size = Vector2(OS.window_size.x, _new_value)
func _get_screen_height():
	return ProjectSettings.get_setting("display/window/size/height")

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
