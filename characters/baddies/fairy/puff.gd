extends CharacterBody2D

@onready var thorne = $"../../Thorne"
@onready var sprite = $sprite
@export var speed = 2000
@onready var area = $Area2D
var attacking = false
var angle = Vector2(1, 0)

func _ready():
	sprite.frame = randi_range(0,7)
	print(sprite.frame)
	
func _physics_process(delta):
	sprite.rotate(PI/22)
	if attacking:
		velocity = angle * speed
		move_and_slide()
	
func attack():
	attacking = true
	angle = global_position.direction_to(thorne.global_position)

func hit(body):
	body.hit(area)
	call_deferred("queue_free")

func die():
	call_deferred("queue_free")
