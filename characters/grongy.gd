extends AnimatedSprite2D

@onready var thorne := get_node("res://characters/thorne.tscn")
var navigate = 1
@export var speed = 100

func _ready():
	play("attack!")

func _process(delta):
	
	navigate = (thorne.global_position.x - global_position.x) > 0
	if navigate:
		navigate = speed
	else:
		navigate = -speed
	global_position.x += navigate * delta
