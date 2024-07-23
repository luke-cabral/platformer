extends Node2D

@onready var thorne = $"../Thorne"
@onready var zero = $".."

func _process(delta):
	if Input.is_action_just_pressed("teleport"):
		thorne.global_position = global_position
		zero.spawn = global_position
