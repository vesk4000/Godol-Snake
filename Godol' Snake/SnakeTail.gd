extends Node2D

var tile_size = 20
var tile_padding = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.set_size(Vector2(tile_size, tile_size))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
