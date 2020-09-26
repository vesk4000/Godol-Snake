extends Node2D


# Game states
enum GameStates {PAUSED, RUNNING, DYING, DIED}
var game_state = GameStates.PAUSED
var game_has_started = false

# Game
var score = 0
var time = 0

# Drection
var direction = Vector2(1, 0)
var old_direction = direction

# FPS
var movement_fps = 10 setget _set_movement_fps
func _set_movement_fps(_new_movement_fps):
	movement_fps = _new_movement_fps
	move_frames_per_forced_frame = round(forced_fps / _new_movement_fps)

var forced_fps = 100
var move_frames_per_forced_frame = round(forced_fps / movement_fps)
var fps_counter = 0

# Tail
const SnakeTail = preload("res://SnakeTail.tscn")
var tail_to_add = 6
var tail = []
var _last_tail_pos

# Death
var flicker
const GameOverMenu = preload("res://UI/GameOverMenu.tscn")

# Setup
func _ready():
	Global.restart()
	Global.setup_rects(self)
	
	if get_parent().has_node("Fruit"):
# warning-ignore:return_value_discarded
		$"../Fruit".connect("was_eaten", self, "_eat_fruit")
	
	# Add the tail that you start with
	_last_tail_pos = position
# warning-ignore:unused_variable
	for i in range(tail_to_add):
		_last_tail_pos.x -= Global.tile_size
		_add_to_tail()
	tail_to_add = 0
	_animate_snake()


# The main loop of the game
func _process(delta):
	if game_state != GameStates.RUNNING:
		return
	
	# Handle time
	time += delta
	if(time >= 60):
		get_parent().get_parent().get_node("GUI/HUD/Time").text = \
				"Time: " + str(int(time) / 60) + "m " + str(int(time) % 60) + "s"
	else:
		get_parent().get_parent().get_node("GUI/HUD/Time").text = \
				"Time: " + str(int(time)) + "s"
	
	# Handle Direction
	_set_direction()
	
	# Handle Sprinting
	if Input.is_action_pressed("sprint"):
		self.movement_fps = 20
	else:
		self.movement_fps = 10
	
	# Move the snake
	fps_counter += 1
	if fps_counter >= move_frames_per_forced_frame:
		fps_counter = 0
		
		# Check for collision with the rest of the snake
		var has_collided = false
		var new_snake_head = position + direction * Global.tile_size
		for i in range(tail.size()):
			if new_snake_head == tail[i].position \
					and not (i == tail.size() - 1 and tail_to_add == 0):
				has_collided = true
				break
		if has_collided:
			die()
			return
		
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
		
		# This is used for making sure that you can't
		# change your direction to the opposite direction
		old_direction = direction
		
		# Animate Snake
		_animate_snake();


# Handle Death
func die():
	game_state = GameStates.DYING
	Global.quick_timer(self, 3, "has_died")
	flicker = Global.quick_flicker(self, 0.25, "hide_snake", "show_snake")

func hide_snake():
	self.visible = false
	for i in range(tail.size()):
		tail[i].visible = false

func show_snake():
	self.visible = true
	for i in range(tail.size()):
		tail[i].visible = true

func has_died():
	flicker.queue_free()
	call_deferred("show_snake")
	game_state = GameStates.DIED
	var game_over_menu = GameOverMenu.instance()
	get_node("../../GUI").add_child(game_over_menu)


# Gets the input and sets the direction of the snake accordingly
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


# Add a tail piece to the snake
func _add_to_tail():
	var _snake_tail = SnakeTail.instance()
	get_node("../").call_deferred("add_child", _snake_tail)
	Global.setup_rects(_snake_tail)
	tail.append(_snake_tail)
	tail[tail.size() - 1].position = _last_tail_pos


# Eat fruit
func _eat_fruit():
	tail_to_add += 1
	score += 1
	get_parent().get_parent().get_node("GUI/HUD/Score").text = "Score: " + str(score)

# Animate each part of the snake
# checks where the _check part of the snake is comapred to the _root
# and animates(unhides the surrounding rectangles) accordingly
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


# Animate the whole snake
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


# Hide all of the rectangles used for animation
func _hide_rect(var _node):
	_get_top_rect(_node).hide()
	_get_bottom_rect(_node).hide()
	_get_left_rect(_node).hide()
	_get_right_rect(_node).hide()


# Interface for easier access to the rectagnles used for animation
func _get_top_rect(var _node):
	return _node.get_node("Rect/TopColorRect")
func _get_bottom_rect(var _node):
	return _node.get_node("Rect/BottomColorRect")
func _get_left_rect(var _node):
	return _node.get_node("Rect/LeftColorRect")
func _get_right_rect(var _node):
	return _node.get_node("Rect/RightColorRect")


# Signal connected to the Main Menu in order to start the game
func _on_MainMenu_start_game():
	var HUD = load("res://UI/HUD.tscn")
	var _hud = HUD.instance()
	get_parent().get_parent().get_node("GUI").add_child(_hud)
	game_state = GameStates.RUNNING
