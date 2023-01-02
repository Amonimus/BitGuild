extends "res://script/GUI/Window.gd"

# Methods
func drawContent():
	var el = LineEdit.new()
	add_child(el)
	el.rect_position =  Vector2(-100, 0)
	el.rect_size = Vector2(128, 24)
	el.connect("text_entered", self, "textEnter")

func textEnter(new_text):
	gameControl.ArbitraryExecution(new_text)
