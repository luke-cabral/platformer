extends CharacterBody2D

@onready var see = $thornesee
@onready var cam = $Cam
@onready var swing = $swing

@export var scroll_speed = 0.4
@export var size = 0.2

var falling = false
var oldy = 0
var health = 3

func _ready():
	see.scale = Vector2(size, size)

func _process(delta):
	if (global_position.y - oldy) > 100 or falling:
		oldy = global_position.y + 300
		if cam.timey < 8:
			cam.timey += .1
		if !falling:
			falling = true
			see.play("jump")
			
	if (global_position.y - oldy) < -400:
		oldy = lerp(oldy, global_position.y + 300, scroll_speed)
	
	if is_on_floor():
		oldy = global_position.y
		if cam.timey >2:
			cam.timey -= .7
		falling = false
	
	cam.where(global_position.x, oldy)

func hit(body):
	if body.is_in_group("bad"):
		damaged()
	elif body.is_in_group("wall"):
		swing.flip()
		
func damaged():
	health -= 1
	print(health)
