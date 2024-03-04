extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var speed = 500
@export var health = 3
var east : bool = false

func _ready():
	sprite.play("attack!")

func _process(delta):
	
	if east:
		velocity.x = speed
		sprite.flip_h = false
	else:
		velocity.x = -speed
		sprite.flip_h = true
	
	move_and_slide()
	
func navigate(thornex):
	east = (thornex - global_position.x) > 0
	
func hit():
	sprite.play("hit")
	health -= 1
	if health < 1:
		queue_free()


func hitover():
	sprite.play("attack!")
	
