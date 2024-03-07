extends state

@onready var thorne := $".."
@onready var thornesee := $"../thornesee"
@onready var grounded: state = $"../grounded"
@onready var arm = $"../arm"

func start():
	super.start()
	thornesee.flip_h = false
	thornesee.play("wall")
	thornesee.scale = Vector2(0.38, 0.38)
	thornesee.offset = Vector2(-279, 60)
	thorne.rotation = arm.wall_angle.rotated(PI).angle()
	if arm.wall_angle.x > 0:
		thornesee.flip_v = true
	
func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		thornesee.scale = Vector2(0.2, 0.2)
		thorne.rotation = 0
		thornesee.flip_v = false
		thornesee.play("jump")
		thorne.velocity.y -= grounded.jump_force
		grounded.jump_buffer_counter = 0
		grounded.coyote_counter = 0
		stop(grounded)
	
