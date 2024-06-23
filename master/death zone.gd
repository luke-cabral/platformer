extends Area2D

@onready var zero = $".."

func failure(body):
	zero.dead()
