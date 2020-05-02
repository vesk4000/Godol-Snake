extends Button

export var default_for_focus = false
const left_rect_width = 5

func _ready():
	if default_for_focus:
		self.grab_focus()

func _draw():
	if self.get_focus_owner() == self:
		draw_rect(Rect2(0, 0, rect_size.x, rect_size.y), Color(1, 1, 1, 0.3));
		draw_rect(Rect2(-left_rect_width, 0, left_rect_width, rect_size.y), Color(1, 1, 1, 1));

func _on_Button_mouse_entered():
	self.grab_focus();
