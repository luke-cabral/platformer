extends CharacterBody2D

@onready var see = $thornesee
@onready var cam = $Cam
@onready var swing = $swing

var falling = false
var oldy = 0
var health = 3

func _process(delta):
	
	if (global_position.y - oldy) > 100 or falling:
		oldy = global_position.y + 300
		if cam.timey < 8:
			cam.timey += .1
		if !falling:
			falling = true
			see.play("jump")
	
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
	
func debug():
	var thorne_pos = global_position  # Assume this script is attached to Thorn
	var end_velocity = thorne_pos + velocity.normalized() * 50  # Adjust length as needed
	draw_line(thorne_pos, end_velocity, Color(0, 1, 0, 1), 2)  # Draw velocity in green

