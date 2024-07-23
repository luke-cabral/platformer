extends CharacterBody2D

@onready var sprite = $Sprite2D
@export var speed: int = 500
var right: bool = true

func _ready():
	velocity.x = -speed

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if right:
			velocity.x = speed
			sprite.flip_h = true
			right = false
		else:
			velocity.x = -speed
			sprite.flip_h = false
			right = true
			
