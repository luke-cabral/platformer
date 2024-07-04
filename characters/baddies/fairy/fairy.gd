extends CharacterBody2D

@onready var thorne = $"../Thorne"
@export var radius = 1234
@export var speed = 700

func _ready():
	var angle = Vector2(randf_range(-1, 1), randf_range(-1, 0)).normalized()
	global_position = thorne.global_position + (angle * radius)
	
func _physics_process(delta):
	var angle = position.direction_to(thorne.global_position)
	velocity = angle * speed
	move_and_slide()

func hit(area):
	queue_free()
