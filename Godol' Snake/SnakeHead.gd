extends Node2D

enum GameStates {PAUSED, RUNNING, END}
var game_state = GameStates.PAUSED
var game_has_started = false

# Initialise direction
var direction = Vector2(1, 0)
var old_direction = direction

# Initialise FPS
var movement_fps = 10
var forced_fps = 100
var move_frames_per_forced_frame = round(forced_fps / movement_fps)
var fps_counter = 0

# Initialise the tail
const SnakeTail = preload("res://SnakeTail.tscn")
var tail_to_add = 6
var tail = []
var _last_tail_pos

func _ready():
	Global.setup_rects(self)
	if get_parent().has_node("Fruit"):
		$"../Fruit".connect("was_eaten", self, "_eat_fruit")

func _add_to_tail():
	var _snake_tail = SnakeTail.instance()
	get_node("../").add_child(_snake_tail)
	tail.append(_snake_tail)
	tail[tail.size() - 1].position = _last_tail_pos

func _eat_fruit():
	tail_to_add += 1


func _process(_delta):
	print(tail.size())
	if game_state == GameStates.PAUSED and !game_has_started:
		game_has_started = true
		_last_tail_pos = position
		for i in range(tail_to_add):
			_last_tail_pos.x -= Global.tile_size
			_add_to_tail()
		tail_to_add = 0
		_animate_snake()
	
	if game_state != GameStates.RUNNING:
		return
	
	fps_counter += 1
	
	# Handle direction
	_set_direction()
	
	# Move the snake
	if fps_counter >= move_frames_per_forced_frame:
		fps_counter = 0
		
		# Get the position of the very last element of the snake
		# so that we can create a tail part behind the snake
		if(tail.size() > 0):
			_last_tail_pos = tail[tail.size() - 1].position
		else:
			_last_tail_pos = position
		
		# Move the tail
		if(tail.size() > 0):
			for i in range(tail.size() - 1, -1, -1): # for(int i = tail.size(); i >= 0; i--)
				if i == 0:
					tail[i].position = position
				else:
					tail[i].position = tail[i - 1].position
		
		# Add to the tail
		if(tail_to_add > 0):
			tail_to_add -= 1
			_add_to_tail()
		
		# Move the snake's head
		position.x += direction.x * Global.tile_size
		position.y += direction.y * Global.tile_size
		position.x = Global.wrap(position.x, 0, Global.screen_width)
		position.y = Global.wrap(position.y, 0, Global.screen_height)
		
	# Animate Snake
	_animate_snake();


func _set_direction():
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
	if fps_counter >= move_frames_per_forced_frame:
		old_direction = direction


func _animate(var _root, var _check):
	# Above
	if Global.wrap(_root.position.y - Global.tile_size, 0, Global.screen_height) == _check.position.y:
		_get_top_rect(_root).show()
	# Below
	if Global.wrap(_root.position.y + Global.tile_size, 0, Global.screen_height) == _check.position.y:
		_get_bottom_rect(_root).show()
	# Right
	if Global.wrap(_root.position.x + Global.tile_size, 0, Global.screen_width) == _check.position.x:
		_get_right_rect(_root).show()
	# Left
	if Global.wrap(_root.position.x - Global.tile_size, 0, Global.screen_width) == _check.position.x:
		_get_left_rect(_root).show()

func _animate_snake():
	# Animate Head
	if tail.size() > 0:
		_hide_rect(self)
		_animate(self, tail[0])
		_hide_rect(tail[0])
		_animate(tail[0], self)
	# Animate Tail
	if tail.size() > 1:
		_animate(tail[0], tail[1])
		_hide_rect(tail[tail.size() - 1])
		_animate(tail[tail.size() - 1], tail[tail.size() - 2])
	if tail.size() > 2:
		for i in range(1, tail.size() - 1):
			_hide_rect(tail[i])
			_animate(tail[i], tail[i + 1])
			_animate(tail[i], tail[i - 1])


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


func _on_Control_start_game():
	game_state = GameStates.RUNNING
