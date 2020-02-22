extends Node2D

var tile_size = 40
var tile_padding = 6
var direction = Vector2(1, 0)
var old_direction = direction
var movement_fps = 10
var forced_fps = 100
var move_frames_per_forced_frame = round(forced_fps / movement_fps)
var fps_counter = 0

const SnakeTail = preload("res://SnakeTail.tscn")
var tail_left_to_add = 6
var tail = []


func _ready():
	$Rect/MainColorRect.margin_top = tile_padding
	$Rect/MainColorRect.margin_bottom = tile_size - tile_padding
	$Rect/MainColorRect.margin_left = tile_padding
	$Rect/MainColorRect.margin_right = tile_size - tile_padding
	
	$Rect/TopColorRect.set_position(Vector2(tile_padding, 0))
	$Rect/TopColorRect.set_size(Vector2(tile_size - 2 * tile_padding, tile_padding))
	
	$Rect/BottomColorRect.set_position(Vector2(tile_padding, tile_size - tile_padding))
	$Rect/BottomColorRect.set_size(Vector2(tile_size - 2 * tile_padding, tile_padding))
	
	$Rect/LeftColorRect.set_position(Vector2(0, tile_padding))
	$Rect/LeftColorRect.set_size(Vector2(tile_padding, tile_size - 2 * tile_padding))
	
	$Rect/RightColorRect.set_position(Vector2(tile_size - tile_padding, tile_padding))
	$Rect/RightColorRect.set_size(Vector2(tile_padding, tile_size - 2 * tile_padding))


func _process(_delta):
	fps_counter += 1
	
	#Get direction
	var _new_direction = direction
	if Input.is_action_pressed("ui_left") and old_direction.x == 0:
		_new_direction = Vector2(-1, 0)
	if Input.is_action_pressed("ui_right") and old_direction.x == 0:
		_new_direction = Vector2(1, 0)
	if Input.is_action_pressed("ui_down") and old_direction.y == 0:
		_new_direction = Vector2(0, 1)
	if Input.is_action_pressed("ui_up") and old_direction.y == 0:
		_new_direction = Vector2(0, -1)
	direction = _new_direction
	
	# Move the snake
	if fps_counter >= move_frames_per_forced_frame and !Input.is_action_pressed("ui_select"):
		fps_counter = 0
		# Get the position of the very last element of the snake
		# so that we can create a tail part behind the snake
		var _last_tail_pos
		if(tail.size() > 0):
			_last_tail_pos = tail[tail.size() - 1].position
		else:
			_last_tail_pos = position
		# Move the tail
		if(tail.size() > 0):
			for i in range(tail.size() - 1, -1, -1):
				if i == 0:
					tail[i].position = position
				else:
					tail[i].position = tail[i - 1].position
		#Add to the tail
		if(tail_left_to_add > 0):
			tail_left_to_add -= 1
			var _snake_tail = SnakeTail.instance()
			get_node("../").add_child(_snake_tail)
			tail.append(_snake_tail)
			tail[tail.size() - 1].position = _last_tail_pos
		# Move the snake's head
		position.x += direction.x * tile_size
		position.y += direction.y * tile_size
		position.x = Global.wrap(position.x, 0, 600)
		position.y = Global.wrap(position.y, 0, 600)
		old_direction = direction
		
		# Animate
		if tail.size() > 0:
			_hide_rect(self)
			_animate(self, tail[0])
			_hide_rect(tail[0])
			_animate(tail[0], self)
		if tail.size() > 1:
			_animate(tail[0], tail[1])
			_hide_rect(tail[tail.size() - 1])
			_animate(tail[tail.size() - 1], tail[tail.size() - 2])
		if tail.size() > 2:
			for i in range(1, tail.size() - 1):
				_hide_rect(tail[i])
				_animate(tail[i], tail[i + 1])
				_animate(tail[i], tail[i - 1])


func _animate(var _root, var _check):
	# Above
	if Global.wrap(_root.position.y - tile_size, 0, 600) == _check.position.y:
		_get_top_rect(_root).show()
	# Below
	if Global.wrap(_root.position.y + tile_size, 0, 600) == _check.position.y:
		_get_bottom_rect(_root).show()
	# Right
	if Global.wrap(_root.position.x + tile_size, 0, 600) == _check.position.x:
		_get_right_rect(_root).show()
	# Left
	if Global.wrap(_root.position.x - tile_size, 0, 600) == _check.position.x:
		_get_left_rect(_root).show()

func _hide_rect(var _node):
	_get_bottom_rect(_node).hide()
	_get_top_rect(_node).hide()
	_get_left_rect(_node).hide()
	_get_right_rect(_node).hide()

func _get_top_rect(var _node):
	return _node.get_node("Rect/TopColorRect")
func _get_bottom_rect(var _node):
	return _node.get_node("Rect/BottomColorRect")
func _get_left_rect(var _node):
	return _node.get_node("Rect/LeftColorRect")
func _get_right_rect(var _node):
	return _node.get_node("Rect/RightColorRect")
