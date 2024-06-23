extends Area2D

@export var height = 300
@export var shift = 0
@onready var zero = $".."
var unused: bool = true

func update_spawn(body):
	print(zero)
	if unused:
		zero.spawn = Vector2(position.x + shift, position.y - height)
		unused = false
