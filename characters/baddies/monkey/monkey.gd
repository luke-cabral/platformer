extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var grounded = $"../Thorne/grounded"
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
			
func attack(body):
	set_physics_process(false)
	timer.start()
	grounded.set_physics_process(false)

func release():
	set_physics_process(true)
	grounded.set_physics_process(true)
	
