extends Area2D

@onready var sprite = $Sprite2D
@export var ground = false
var color: int = randi_range(0, 7)

func _ready():
	sprite.frame = color
	sprite.flip_v = ground
	print(color)

func push(area):
	sprite.frame = color + 8
