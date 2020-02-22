extends Node2D

var tile_size = 20
var tile_padding = 2
var direction = Vector2(1, 0)
var old_direction = direction
var movement_fps = 10
var forced_fps = 100
var move_frames_per_forced_frame = round(forced_fps / movement_fps)
var fps_counter = 0

const SnakeTail = preload("res://SnakeTail.tscn")
var tail_left_to_add = 4
var tail = []


func _ready():
	$MainColorRect.margin_top = tile_padding
	$MainColorRect.margin_bottom = tile_size - tile_padding
	$MainColorRect.margin_left = tile_padding
	$MainColorRect.margin_right = tile_size - tile_padding
	
	$TopColorRect.margin_top = 0
	$TopColorRect.margin_bottom = tile_padding
	$TopColorRect.margin_left = tile_padding
	$TopColorRect.margin_right = tile_size - tile_padding
	
	$BottomColorRect.margin_top = tile_size - tile_padding
	$BottomColorRect.margin_bottom = tile_size
	$BottomColorRect.margin_left = tile_padding
	$BottomColorRect.margin_right = tile_size - tile_padding


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
	if fps_counter >= move_frames_per_forced_frame:
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
