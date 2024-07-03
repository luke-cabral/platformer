extends CharacterBody2D

@export var endy = -150
@export var endx = 0
@export var move_time: float = 2.4
var end = Vector2(0, 0)
var direction = Vector2(1, 0)
var distance = 0

func _ready():
	end = position + Vector2(endx, endy)
	direction = position.direction_to(end)
	distance = position.distance_to(end)
	velocity = direction * distance / move_time
	set_process(false)

func _process(delta):
	move_and_slide()
	move_time = move_time - delta
	if move_time <= 0:
		set_process(false)
		
		
