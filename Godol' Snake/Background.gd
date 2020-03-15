extends Node2D


var colors = [Color("#222222"), Color("#262626")]

func _draw():
	var curr_color = 0
	var curr_ver_color = 0
	for i in range(Global.screen_width / Global.tile_size): # Vertical
		curr_color = curr_ver_color
		curr_ver_color = 1 if curr_ver_color == 0 else 0
		for j in range(Global.screen_height / Global.tile_size): # Horizontal
			draw_rect(Rect2(j * Global.tile_size, i * Global.tile_size,
					Global.tile_size, Global.tile_size),
					colors[curr_color])
			curr_color = 1 if curr_color == 0 else 0
