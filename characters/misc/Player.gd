extends CharacterBody2D

@onready var see = $Playersee
@export var  max_speed: int = 400
@export var gravity: float = 55
@export var jump_force: int = 1600
@export var acceleration: int = 500

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000
			
	if Input.is_action_pressed("ui_right"):
		velocity.x = max_speed
		see.flip_h = true
		see.play("walk")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -max_speed
		see.flip_h = false
		see.play("walk")
	else:
		velocity.x = 0
		see.play("still")
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = -jump_force
			
	move_and_slide()


