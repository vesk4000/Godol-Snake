extends Node2D

var tile_size = 20
var tile_padding = 2
var direction = Vector2(1, 0)
var movement_fps = 10
var forced_fps = 100
var move_frames_per_forced_frame = round(forced_fps / movement_fps)
var fps_counter = 0
var old_direction = direction

const SnakeTail = preload("res://SnakeTail.tscn")
var tail_length = 4
var tail_left_to_add = tail_length
var tail = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.set_size(Vector2(tile_size, tile_size))
	#$ColorRect.set_size(Vector2(10, 10))


func _process(_delta):
	fps_counter += 1
	
	direction = _get_direction(old_direction)
	
	if fps_counter >= move_frames_per_forced_frame:
		# Move the snake's tail
		var _last_tail_pos
		if(tail.size() > 0):
			_last_tail_pos = tail[tail.size() - 1].position
		else:
			_last_tail_pos = position
		if(tail.size() > 0):
			for i in range(tail.size() - 1, -1, -1):
				if i == 0:
					tail[i].position = position
				else:
					tail[i].position = tail[i - 1].position
		if(tail_left_to_add > 0):
			tail_left_to_add -= 1
			var _snake_tail = SnakeTail.instance()
			get_node("../").add_child(_snake_tail)
			tail.append(_snake_tail)
			tail[tail.size() - 1].position = _last_tail_pos
		if tail.size() > 0:
			for i in range(0, tail.size()):
				print(str(i) + " " + str(tail[i].position))
		
		# Move the snake's head
		fps_counter = 0
		position.x += direction.x * tile_size
		position.y += direction.y * tile_size
		position.x = Global.wrap(position.x, 0, 600)
		position.y = Global.wrap(position.y, 0, 600)
		old_direction = direction


func _get_direction(_direction : Vector2) -> Vector2:
	var _new_direction = _direction
	if Input.is_action_pressed("ui_left") and _direction.x == 0:
		_new_direction = Vector2(-1, 0)
	if Input.is_action_pressed("ui_right") and _direction.x == 0:
		_new_direction = Vector2(1, 0)
	if Input.is_action_pressed("ui_down") and _direction.y == 0:
		_new_direction = Vector2(0, 1)
	if Input.is_action_pressed("ui_up") and _direction.y == 0:
		_new_direction = Vector2(0, -1)
	return _new_direction
