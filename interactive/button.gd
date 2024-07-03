extends Area2D

@onready var sprite = $Sprite2D
@export var ground = false
@export var face_left = false
@export var face_right = false
@export var mydoor: CharacterBody2D
var color: int = randi_range(0, 7)

func _ready():
	sprite.frame = color
	sprite.flip_v = ground
	if face_left:
		rotation = PI/2
		position.x -= 15
	elif face_right:
		rotation = -PI/2
		position.x += 15

func push(area):
	sprite.frame = color + 8
	mydoor.set_process(true)
