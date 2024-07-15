extends CharacterBody2D

@onready var thorne = $"../Thorne"
@export var radius = 1234
@export var speed = 1000
@export var rspeed = 0.5
@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer
var puff = load("res://characters/baddies/fairy/puff.tscn")
var attacking = false

func _ready():
	var angle = Vector2(randf_range(-1, 1), randf_range(-1, 0)).normalized()
	global_position = thorne.global_position + (angle * radius)
	
func _physics_process(delta):
	var direction = global_position.angle_to_point(thorne.global_position)
	rotation = lerp_angle(rotation, direction, rspeed)
	print(rotation)
	sprite.flip_v = rotation > PI/2 or rotation < -PI / 2
	if !attacking:
		var angle = position.direction_to(thorne.global_position)
		velocity = angle * speed
		move_and_slide()

func hit():
	queue_free()

func attack(body):
	attacking = true
	if timer.is_stopped():
		timer.start()
	
func seek(body):
	attacking = false

func new_puff():
	var new_puff = puff.instantiate()
	add_child(new_puff)
	timer.wait_time = randf_range(1.6, 3)
