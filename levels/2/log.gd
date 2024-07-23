extends CharacterBody2D

@onready var timer = $Timer
@export var acceleration: int = -38.5

func _ready():
	set_physics_process(false)

func activate():
	set_physics_process(true)
	timer.start()

func swap():
	acceleration *= -1
	
func _physics_process(delta):
	velocity.y += acceleration
	move_and_slide()
