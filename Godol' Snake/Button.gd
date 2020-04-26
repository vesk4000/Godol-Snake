extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_focus_entered():
	var font = self.get_font("font", "")
	font.size = 56
	self.add_font_override("font", font)


func _on_Button_focus_exited():
	var font = self.get_font("font", "")
	font.size = 32
	self.add_font_override("font", font)
