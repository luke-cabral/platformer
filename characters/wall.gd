extends state

@onready var thorne := $".."
@onready var thornesee := $"../thornesee"
@onready var grounded: state = $"../grounded"
@onready var arm = $"../arm"
@onready var butler = $"../grounded/butler"

@export var climb_speed = 175

var distance = 0
var upper = 44
var downer = 77
var up = upper
var down = downer

func start():
	super.start()
	thornesee.flip_h = false
	thornesee.play("wall")
	thornesee.scale = Vector2(0.38, 0.38)
	thornesee.offset = Vector2(-279, 60)
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
	
	if Input.is_action_just_pressed("jump"):
		thornesee.scale = Vector2(0.2, 0.2)
		thorne.rotation = 0
		thornesee.flip_v = false
		grounded.jump_buffer_counter = 100
		grounded.coyote_counter = 100
		stop(grounded)
		
	if Input.is_action_pressed("ui_up"):
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
		
	
