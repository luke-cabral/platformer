extends state

@onready var thorne := $".."
@onready var thornesee := $"../thornesee"
@onready var grounded: state = $"../grounded"
@onready var arm = $"../arm"
@onready var butler = $"../grounded/butler"
@onready var body = $"../body"

@export var climb_speed = 175
@export var walljump_counter = 7

var distance = 0
var upper = 30
var downer = 90
var up = upper
var down = downer
var walljump := 0
var wj := false
var right := false

func start():
	super.start()
	thornesee.flip_h = false
	thornesee.play("wall")
	thornesee.offset = Vector2(-279, 60)
	thornesee.scale = Vector2(0.38, 0.38)
	thorne.rotation = arm.wall_angle.rotated(PI).angle()
	if arm.wall_angle.x > 0:
		thornesee.flip_v = true
		butler.rotation = -PI/2
		up = downer
		down = upper
	else:
		up = upper
		down = downer
	butler.global_position = global_position
	butler.force_raycast_update()
	distance = butler.get_collision_point().distance_to(butler.global_position)
	
func _physics_process(delta):
	
	if Input.is_action_just_pressed("jump") and !wj:
		thorne.velocity.y -= grounded.jump_force
		thorne.rotation = 0
		thornesee.play("jump")
		thornesee.scale = Vector2(thorne.size, thorne.size)
		thornesee.flip_v = false
		if arm.wall_angle.x > 0:
			thorne.velocity.x = 900
			thornesee.offset = Vector2(10, 0)
			right = true
		else:
			thorne.velocity.x = -900
			thornesee.flip_h = true
			thornesee.offset = Vector2(-20, 0)
			right = false
		wj = true
		walljump = walljump_counter
		
	if wj:
		walljump -= 1
		thorne.velocity.y += grounded.gravity
		if Input.is_action_pressed("ui_right") and !right:
			thorne.velocity.x += 150
		elif Input.is_action_pressed("ui_left") and right:
			thorne.velocity.x -= 150
		if walljump < 1:
			wj = false
			print(thorne.rotation, thornesee.rotation, thornesee.offset, body.rotation)
			stop(grounded)
	elif Input.is_action_pressed("ui_up"):
		butler.global_position = global_position
		butler.global_position.y -= up
		butler.force_raycast_update()
		if floor(butler.get_collision_point().distance_to(butler.global_position)) == floor(distance):
			thorne.velocity.y = -climb_speed
	elif Input.is_action_pressed("ui_down"):
		butler.global_position = global_position
		butler.global_position.y += down
		butler.force_raycast_update()
		if floor(butler.get_collision_point().distance_to(butler.global_position)) == floor(distance):
			thorne.velocity.y = climb_speed
	else:
		thorne.velocity = Vector2.ZERO
			
	thorne.move_and_slide()
