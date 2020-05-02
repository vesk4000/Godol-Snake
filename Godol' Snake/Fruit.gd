extends Node2D


signal was_eaten
 
func _ready():
	$ColorRect.margin_left = Global.tile_padding
	$ColorRect.margin_right = Global.tile_size - Global.tile_padding
	$ColorRect.margin_top = Global.tile_padding
	$ColorRect.margin_bottom = Global.tile_size - Global.tile_padding
	#_new_position()


# Check if the fruit has been eaten
func _process(_delta):
	if _collides_with_snake(position):
		emit_signal("was_eaten")
		_new_position()

# Generates a new position for the fruit.
# Creates the illusion of a new fruit being spawned,
# but it is really the same fruit

func _new_position():
	var _pos = Vector2(_random_position())
	while _collides_with_snake(_pos):
		_pos = Vector2(_random_position())
	position = _pos

func _random_position() -> Vector2:
	var _ans = Vector2(Global.rng.randi_range(0, floor(Global.screen_width / Global.tile_size)),
		Global.rng.randi_range(0, floor(Global.screen_height / Global.tile_size)))
	_ans.x = _ans.x * Global.tile_size
	_ans.y = _ans.y * Global.tile_size
	return _ans

func _collides_with_snake(var _pos) -> bool:
	if !get_parent().has_node("SnakeHead"):
		return false
	var _snake_head = $"../SnakeHead"
	var _snake = []
	_snake.append(_snake_head.position)
	for i in range(_snake_head.tail.size()):
		_snake.append(_snake_head.tail[i].position)
	for i in range(_snake.size()):
		if _snake[i] == _pos:
			return true
	return false
