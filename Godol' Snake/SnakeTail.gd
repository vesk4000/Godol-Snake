extends Node2D

var tile_size = 40
var tile_padding = 6

# Called when the node enters the scene tree for the first time.
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
	pass
