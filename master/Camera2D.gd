extends Camera2D

@export var offsety = 203
var timex = 6.0
var timey = 2.0
var target_position = Vector2(0, -offsety)

func _process(delta):
	global_position.x = lerp(global_position.x, target_position.x, timex * delta)
	global_position.y = lerp(global_position.y, target_position.y, timey * delta)

func where(newx, newy):
	target_position = Vector2(newx, newy - offsety)
